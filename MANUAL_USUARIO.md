# Manual para Principiantes (Paso a Paso)
## Sistema de Gestion Documental

Version: 2.0  
Fecha: 27 de marzo de 2026  
Nivel del manual: Basico (explicado para principiantes)

---

## 1) Para que sirve este sistema

Este sistema te ayuda a:

- Crear y organizar tareas.
- Asignar responsables por area.
- Subir archivos de evidencia.
- Crear requisiciones de compra.
- Dar seguimiento al estado de cada proceso.

Piensalo como una oficina digital donde todo queda ordenado y con historial.

---

## 2) Tipos de usuario (roles)

### Admin global
Puede ver y editar todo en todas las areas.

### Admin por area (`area_admin`)
Puede ver y editar solo lo de su area.

### Usuario operativo
Trabaja tareas, sube archivos y crea requisiciones.

> Importante: los usuarios creados automaticamente (`area_admin_*`) SI se pueden editar.  
Puedes cambiarles nombre, correo, contrasena, rol y estado desde el modulo de usuarios.

---

## 3) Como entrar al sistema

1. Abre tu navegador.
2. Escribe la URL del sistema (ejemplo: `http://localhost:3110`).
3. Veras la pantalla de inicio de sesion.
4. Escribe:
   - Usuario
   - Contrasena
5. Haz clic en el boton **Iniciar sesion**.

Si los datos son correctos, entraras al panel principal.

---

## 4) Que veras al entrar

En el lado izquierdo veras el menu principal.  
Las opciones cambian segun tu rol.

Opciones mas comunes:

- Tareas
- Archivos
- Requisiciones
- Reportes
- Configuracion (solo admin)
- Cerrar sesion

---

## 5) Crear una nueva area (solo admin)

1. En el menu izquierdo, haz clic en **Configuracion** o **Administracion**.
2. Haz clic en **Areas**.
3. Haz clic en el boton **Crear Area**.
4. Llena los campos:
   - Nombre del area (ejemplo: Contabilidad)
   - Descripcion (opcional)
5. Haz clic en **Guardar**.

Resultado:

- El area queda creada.
- El sistema puede crear un usuario admin del area automaticamente.

### Muy importante despues de crear area

1. Ve a **Usuarios**.
2. Busca el usuario `area_admin_*` recien creado.
3. Haz clic en **Editar**.
4. Cambia:
   - Correo (por uno real)
   - Contrasena (segura)
   - Si quieres, nombre de usuario
5. Haz clic en **Guardar cambios**.

---

## 6) Crear un usuario nuevo (solo admin)

1. Menu izquierdo -> **Usuarios**.
2. Haz clic en **Crear usuario**.
3. Llena:
   - Usuario
   - Correo
   - Contrasena
   - Rol
4. Haz clic en **Guardar**.

Si todo sale bien, veras un mensaje de exito.

---

## 7) Editar un usuario (incluye auto-creados)

1. Menu -> **Usuarios**.
2. Busca el usuario en la tabla.
3. Haz clic en **Editar**.
4. Modifica lo que necesites:
   - Usuario
   - Correo
   - Rol
   - Activo/inactivo
   - Contrasena (si quieres cambiarla)
5. Haz clic en **Guardar**.

---

## 8) Eliminar usuario

1. Menu -> **Usuarios**.
2. Busca el usuario.
3. Haz clic en **Eliminar**.
4. Confirma la accion.

Si no deja eliminar:

- Verifica que no sea el admin principal.
- Intenta refrescar y volver a intentar.
- Revisa que tengas permisos de admin global.

---

## 9) Asignar usuarios a un area

1. Ve a **Areas**.
2. En la fila del area, haz clic en **Ver**.
3. Haz clic en **Asignar usuarios**.
4. Marca o selecciona los usuarios.
5. Haz clic en **Guardar asignaciones**.

Esto define que informacion vera cada usuario.

---

## 10) Crear una tarea manual

1. Menu -> **Tareas** -> **Crear tarea**.
2. Llena el formulario:
   - Titulo
   - Descripcion
   - Area
   - Asignado a (opcional)
   - Prioridad
   - Fecha limite (opcional)
3. Haz clic en **Guardar**.

Al guardar, la tarea queda visible en la lista segun permisos.

---

## 11) Ver y actualizar una tarea

1. Ve a **Tareas** -> **Mis tareas**.
2. Haz clic en el titulo de la tarea para abrir detalle.
3. En la seccion de estado, selecciona:
   - Pendiente
   - En progreso
   - Completada
4. El cambio se guarda.

---

## 12) Subir archivos a una tarea

1. Abre la tarea (detalle).
2. Busca la seccion **Archivos**.
3. Haz clic en **Subir archivo**.
4. Selecciona el archivo de tu computadora.
5. Haz clic en **Confirmar/Subir**.

Veras el archivo en la lista cuando termine.

---

## 13) Crear una tarea programada (recurrente)

1. Menu -> **Tareas** -> **Tareas programadas**.
2. Haz clic en **Crear tarea programada**.
3. Llena las 3 secciones:

### A) Datos de la tarea
- Titulo
- Descripcion
- Area
- Prioridad

### B) Usuarios
- Busca usuarios por nombre/rol/area.
- Haz clic en **Agregar** para pasarlos a seleccionados.

### C) Configuracion
- Frecuencia (diaria, semanal, mensual, etc.)
- Intervalo
- Hora de ejecucion
- Fecha inicio y fin (si aplica)

4. Haz clic en **Guardar**.

El sistema generara tareas automaticamente segun tu configuracion.

---

## 14) Crear una requisicion de compra

1. Menu -> **Requisiciones** -> **Mis requisiciones**.
2. Haz clic en **Nueva requisicion**.
3. Llena:
   - Titulo
   - Descripcion
   - Monto estimado
   - Area
   - Dirigida a (quien revisa/aprueba)
4. Haz clic en **Enviar requisicion**.

---

## 15) Estados de requisicion (como leerlos)

- **Enviada**: se acaba de crear.
- **Revisada**: el responsable ya la reviso.
- **Aprobada**: fue aceptada.

Puedes ver esto en la linea de tiempo del detalle.

---

## 16) Donde ver requisiciones

### Mis requisiciones
Las que tu creaste.

### Requisiciones asignadas
Las que te mandaron a ti para revisar/aprobar.

### Requisiciones de mi area (`area_admin`)
Solo las de tu area.

### Todas las requisiciones (`admin`)
Vista global completa.

---

## 17) Flujos recomendados (muy practicos)

### Para admin al iniciar el sistema
1. Crear areas.
2. Revisar usuarios auto-creados `area_admin_*`.
3. Editar correo y contrasena de esos usuarios.
4. Crear usuarios operativos.
5. Asignar usuarios a areas.
6. Crear tareas base.
7. Crear tareas programadas.

### Para usuario operativo en el dia a dia
1. Entrar a **Mis tareas**.
2. Abrir tarea.
3. Cambiar estado a **En progreso**.
4. Subir evidencia.
5. Cambiar a **Completada**.
6. Si necesita compras, crear requisicion.

---

## 18) Errores comunes y solucion simple

### No veo una tarea
- Revisa que estes asignado al area correcta.
- Pide al admin confirmar tus permisos.

### No puedo editar algo
- Tal vez tu rol no lo permite.
- Si eres `area_admin`, solo puedes editar lo de tu area.

### No me deja borrar usuario
- Puede ser el admin principal (no se borra).
- O no tienes rol admin global.

### No llegan correos
- Revisar configuracion de correo del sistema.
- Verificar que el email del usuario este bien escrito.

---

## 19) Recomendaciones de seguridad

- Cambia todas las contrasenas por defecto.
- No compartas usuarios entre personas.
- Usa correos reales y vigentes.
- Desactiva usuarios que ya no trabajan en el area.

---

## 20) Checklist rapido para administradores

- [ ] Ya cree todas las areas.
- [ ] Ya edite todos los `area_admin_*` (correo + contrasena).
- [ ] Ya asigne usuarios a sus areas.
- [ ] Ya valide que se puedan crear tareas.
- [ ] Ya valide flujo de requisiciones.
- [ ] Ya probe subida y descarga de archivos.

---

Fin del manual.