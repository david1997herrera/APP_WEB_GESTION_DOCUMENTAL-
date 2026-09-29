from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required, current_user
from app.models.restablecimiento_contrasena import RestablecimientoContrasena
from app.models.user import User
from app.services.restablecimiento_contrasena import (
    _resumen,
    cambiar_con_enlace,
    solicitar_enlace,
)
from app.dominio.restablecimiento import enlace_sigue_vigente
from datetime import datetime

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('admin.dashboard'))
    
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        if not username or not password:
            flash('Por favor completa todos los campos', 'error')
            return render_template('auth/login.html')
        
        user = User.query.filter_by(username=username).first()
        
        if user and user.check_password(password) and user.is_active:
            login_user(user)
            flash(f'¡Bienvenido, {user.username}!', 'success')
            
            # Redirigir según el rol
            if user.is_admin():
                return redirect(url_for('admin.dashboard'))
            else:
                return redirect(url_for('task.my_tasks'))
        else:
            flash('Usuario o contraseña incorrectos', 'error')
    
    return render_template('auth/login.html')

@auth_bp.route('/olvide-contrasena', methods=['GET', 'POST'])
def olvide_contrasena():
    if current_user.is_authenticated:
        return redirect(url_for('admin.dashboard'))
    if request.method == 'POST':
        flash(solicitar_enlace(request.form.get('username')), 'info')
        return redirect(url_for('auth.login'))
    return render_template('auth/olvide_contrasena.html')


@auth_bp.route('/restablecer/<token>', methods=['GET', 'POST'])
def restablecer_contrasena(token):
    if current_user.is_authenticated:
        return redirect(url_for('admin.dashboard'))
    registro = RestablecimientoContrasena.query.filter_by(token_hash=_resumen(token)).first()
    vigente = bool(registro and enlace_sigue_vigente(registro.expira_en, registro.usado_en, datetime.utcnow()))
    if request.method == 'POST':
        if not vigente:
            flash('El enlace venció o ya se usó. Solicite uno nuevo.', 'error')
            return redirect(url_for('auth.olvide_contrasena'))
        error = cambiar_con_enlace(
            token,
            request.form.get('password'),
            request.form.get('confirmacion'),
        )
        if error:
            flash(error, 'error')
            return render_template('auth/restablecer_contrasena.html', token=token, vigente=True)
        flash('La contraseña quedó actualizada. Ya puede iniciar sesión.', 'success')
        return redirect(url_for('auth.login'))
    return render_template('auth/restablecer_contrasena.html', token=token, vigente=vigente)


@auth_bp.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Has cerrado sesión correctamente', 'info')
    return redirect(url_for('auth.login'))

@auth_bp.route('/profile')
@login_required
def profile():
    return render_template('auth/profile.html', user=current_user)
