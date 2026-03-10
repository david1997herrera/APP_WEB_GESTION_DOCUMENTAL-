from datetime import datetime

from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user

from app.config import db
from app.models.purchase_requisition import PurchaseRequisition
from app.models.user import User
from app.services.email_service import EmailService


requisition_bp = Blueprint('requisition', __name__)


def admin_required(f):
    from functools import wraps

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated:
            flash('Por favor inicia sesión para acceder a esta página', 'error')
            return redirect(url_for('auth.login'))
        if not current_user.is_admin():
            flash('No tienes permisos para acceder a esta sección', 'error')
            return redirect(url_for('requisition.my'))
        return f(*args, **kwargs)

    return decorated_function


@requisition_bp.route('/create', methods=['GET', 'POST'])
@login_required
def create():
    """Crear nueva requisición de compra (cualquier usuario)."""
    users = User.query.filter_by(is_active=True).all()
    if request.method == 'POST':
        title = request.form.get('title')
        description = request.form.get('description')
        amount = request.form.get('amount')
        target_user_id = request.form.get('target_user_id')

        if not title:
            flash('El título es obligatorio.', 'error')
            return render_template('requisition/create.html')

        try:
            amount_value = float(amount) if amount else None
        except ValueError:
            flash('El monto debe ser numérico.', 'error')
            return render_template('requisition/create.html', users=users)

        requisition = PurchaseRequisition(
            title=title,
            description=description,
            amount=amount_value,
            status='enviada',
            requester_id=current_user.id,
            target_user_id=int(target_user_id) if target_user_id else None,
        )

        try:
            db.session.add(requisition)
            db.session.commit()
            # Notificar al destinatario (o admins si no hay destinatario)
            EmailService.notify_purchase_requisition_created(requisition.id)
            flash('Requisición enviada correctamente.', 'success')
            return redirect(url_for('requisition.view', requisition_id=requisition.id))
        except Exception:
            db.session.rollback()
            flash('Error al crear la requisición.', 'error')

    return render_template('requisition/create.html', users=users)


@requisition_bp.route('/my')
@login_required
def my():
    """Listado de requisiciones creadas por el usuario."""
    requisitions = PurchaseRequisition.query.filter_by(requester_id=current_user.id).order_by(
        PurchaseRequisition.created_at.desc()
    ).all()
    return render_template('requisition/my.html', requisitions=requisitions)


@requisition_bp.route('/assigned')
@login_required
def assigned():
    """Listado de requisiciones dirigidas al usuario actual."""
    requisitions = PurchaseRequisition.query.filter_by(target_user_id=current_user.id).order_by(
        PurchaseRequisition.created_at.desc()
    ).all()
    return render_template('requisition/assigned.html', requisitions=requisitions)


@requisition_bp.route('/')
@login_required
@admin_required
def index():
    """Listado de todas las requisiciones (solo admin)."""
    requisitions = PurchaseRequisition.query.order_by(PurchaseRequisition.created_at.desc()).all()
    return render_template('requisition/index.html', requisitions=requisitions)


@requisition_bp.route('/<int:requisition_id>')
@login_required
def view(requisition_id):
    """Detalle de una requisición."""
    requisition = PurchaseRequisition.query.get_or_404(requisition_id)
    # Solo el solicitante, el destinatario o admin pueden verla
    if (
        not current_user.is_admin()
        and requisition.requester_id != current_user.id
        and requisition.target_user_id != current_user.id
    ):
        flash('No tienes permisos para ver esta requisición.', 'error')
        return redirect(url_for('requisition.my'))
    return render_template('requisition/view.html', requisition=requisition)


@requisition_bp.route('/<int:requisition_id>/review', methods=['POST'])
@login_required
def mark_reviewed(requisition_id):
    """Marcar requisición como revisada (solo destinatario)."""
    requisition = PurchaseRequisition.query.get_or_404(requisition_id)
    if requisition.target_user_id != current_user.id:
        flash('Solo el usuario destinatario puede revisar esta requisición.', 'error')
        return redirect(url_for('requisition.view', requisition_id=requisition.id))
    if requisition.status == 'enviada':
        requisition.status = 'revisada'
        requisition.reviewer_id = current_user.id
        requisition.reviewed_at = datetime.utcnow()
        requisition.updated_at = datetime.utcnow()
        db.session.commit()
        EmailService.notify_purchase_requisition_status_changed(requisition.id)
        flash('Requisición marcada como revisada.', 'success')
    return redirect(url_for('requisition.view', requisition_id=requisition.id))


@requisition_bp.route('/<int:requisition_id>/approve', methods=['POST'])
@login_required
def mark_approved(requisition_id):
    """Marcar requisición como aprobada (solo destinatario)."""
    requisition = PurchaseRequisition.query.get_or_404(requisition_id)
    if requisition.target_user_id != current_user.id:
        flash('Solo el usuario destinatario puede aprobar esta requisición.', 'error')
        return redirect(url_for('requisition.view', requisition_id=requisition.id))
    if requisition.status in ['enviada', 'revisada']:
        requisition.status = 'aprobada'
        requisition.approver_id = current_user.id
        requisition.approved_at = datetime.utcnow()
        requisition.updated_at = datetime.utcnow()
        db.session.commit()
        EmailService.notify_purchase_requisition_status_changed(requisition.id)
        flash('Requisición aprobada.', 'success')
    return redirect(url_for('requisition.view', requisition_id=requisition.id))

