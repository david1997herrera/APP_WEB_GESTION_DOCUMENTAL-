// JavaScript principal para la aplicación de gestión documental

document.addEventListener('DOMContentLoaded', function() {
    // Inicializar tooltips de Bootstrap
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Inicializar popovers de Bootstrap
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });

    // Sidebar functionality
    const sidebar = document.getElementById('sidebar');
    const sidebarToggle = document.querySelector('[data-bs-target="#sidebar"]');
    
    if (sidebar && sidebarToggle) {
        // Auto-close sidebar on mobile when clicking outside
        document.addEventListener('click', function(e) {
            if (window.innerWidth < 992 && sidebar.classList.contains('show')) {
                if (!sidebar.contains(e.target) && !sidebarToggle.contains(e.target)) {
                    const bsOffcanvas = bootstrap.Offcanvas.getInstance(sidebar);
                    if (bsOffcanvas) {
                        bsOffcanvas.hide();
                    }
                }
            }
        });

        // Mark active menu item
        const currentPath = window.location.pathname;
        const menuLinks = sidebar.querySelectorAll('.nav-link[href]');
        menuLinks.forEach(link => {
            if (link.getAttribute('href') === currentPath) {
                link.classList.add('active');
                // Also mark parent menu as active
                const parentMenu = link.closest('.collapse');
                if (parentMenu) {
                    const parentToggle = document.querySelector(`[href="#${parentMenu.id}"]`);
                    if (parentToggle) {
                        parentToggle.classList.add('active');
                        parentMenu.classList.add('show');
                    }
                }
            }
        });

        // Smooth transitions for sidebar
        sidebar.addEventListener('show.bs.offcanvas', function() {
            document.body.style.overflow = 'hidden';
        });

        sidebar.addEventListener('hidden.bs.offcanvas', function() {
            document.body.style.overflow = '';
        });
    }

    // Confirmación para acciones de eliminación
    const deleteButtons = document.querySelectorAll('.btn-delete');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const itemName = this.getAttribute('data-item-name') || 'este elemento';
            if (confirm(`¿Estás seguro de que quieres eliminar ${itemName}?`)) {
                this.closest('form').submit();
            }
        });
    });

    // Auto-hide alerts después de 5 segundos
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Validación de formularios
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(form => {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });

    // Toggle de visibilidad de contraseña
    const togglePasswordButtons = document.querySelectorAll('.toggle-password');
    togglePasswordButtons.forEach(button => {
        button.addEventListener('click', function() {
            const passwordInput = this.previousElementSibling;
            const icon = this.querySelector('i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    });

    // Animación de carga para botones
    const submitButtons = document.querySelectorAll('button[type="submit"]');
    submitButtons.forEach(button => {
        button.addEventListener('click', function() {
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Procesando...';
            this.disabled = true;
            
            // Re-enable after 3 seconds (fallback)
            setTimeout(() => {
                this.innerHTML = originalText;
                this.disabled = false;
            }, 3000);
        });
    });

    // Filtro de búsqueda en tablas
    const searchInputs = document.querySelectorAll('.table-search');
    searchInputs.forEach(input => {
        input.addEventListener('keyup', function() {
            const table = this.closest('.table-responsive').querySelector('table');
            const filter = this.value.toLowerCase();
            const rows = table.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(filter) ? '' : 'none';
            });
        });
    });

    // Contador de caracteres para textareas
    const textareas = document.querySelectorAll('textarea[data-max-length]');
    textareas.forEach(textarea => {
        const maxLength = textarea.getAttribute('data-max-length');
        const counter = document.createElement('small');
        counter.className = 'text-muted';
        counter.innerHTML = `<span class="char-count">0</span>/${maxLength} caracteres`;
        
        textarea.parentNode.appendChild(counter);
        
        textarea.addEventListener('input', function() {
            const currentLength = this.value.length;
            const charCount = this.parentNode.querySelector('.char-count');
            charCount.textContent = currentLength;
            
            if (currentLength > maxLength * 0.9) {
                charCount.classList.add('text-warning');
            } else {
                charCount.classList.remove('text-warning');
            }
        });
    });

    // Smooth scroll para enlaces internos
    const internalLinks = document.querySelectorAll('a[href^="#"]');
    internalLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Auto-resize para textareas
    const autoResizeTextareas = document.querySelectorAll('textarea[data-auto-resize]');
    autoResizeTextareas.forEach(textarea => {
        textarea.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = this.scrollHeight + 'px';
        });
    });

    // Confirmación para formularios importantes
    const importantForms = document.querySelectorAll('form[data-confirm]');
    importantForms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const message = this.getAttribute('data-confirm');
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    });

    // Lazy loading para imágenes
    const lazyImages = document.querySelectorAll('img[data-src]');
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.classList.remove('lazy');
                observer.unobserve(img);
            }
        });
    });

    lazyImages.forEach(img => imageObserver.observe(img));

    // Notificaciones toast personalizadas
    window.showToast = function(message, type = 'info') {
        const toastContainer = document.getElementById('toast-container') || createToastContainer();
        const toast = createToast(message, type);
        toastContainer.appendChild(toast);
        
        const bsToast = new bootstrap.Toast(toast);
        bsToast.show();
        
        // Remove toast after it's hidden
        toast.addEventListener('hidden.bs.toast', () => {
            toast.remove();
        });
    };

    function createToastContainer() {
        const container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container position-fixed top-0 end-0 p-3';
        container.style.zIndex = '9999';
        document.body.appendChild(container);
        return container;
    }

    function createToast(message, type) {
        const toast = document.createElement('div');
        toast.className = `toast align-items-center text-white bg-${type} border-0`;
        toast.setAttribute('role', 'alert');
        toast.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">${message}</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        `;
        return toast;
    }

    // Función para mostrar loading en botones
    window.showButtonLoading = function(button, text = 'Procesando...') {
        const originalContent = button.innerHTML;
        button.innerHTML = `<i class="fas fa-spinner fa-spin"></i> ${text}`;
        button.disabled = true;
        return originalContent;
    };

    window.hideButtonLoading = function(button, originalContent) {
        button.innerHTML = originalContent;
        button.disabled = false;
    };

    // Función para confirmar eliminación con detalles
    window.confirmDelete = function(itemName, itemType = 'elemento') {
        return confirm(`¿Estás seguro de que quieres eliminar ${itemType} "${itemName}"?\n\nEsta acción no se puede deshacer.`);
    };

    // Función para copiar al portapapeles
    window.copyToClipboard = function(text) {
        navigator.clipboard.writeText(text).then(() => {
            showToast('Copiado al portapapeles', 'success');
        }).catch(() => {
            showToast('Error al copiar', 'danger');
        });
    };

    // Inicializar animaciones de entrada
    const animatedElements = document.querySelectorAll('.fade-in');
    const animationObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'fadeIn 0.5s ease-in-out';
            }
        });
    });

    animatedElements.forEach(el => animationObserver.observe(el));
});

// Funciones globales para uso en templates
window.formatDate = function(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-ES', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
};

window.formatCurrency = function(amount) {
    return new Intl.NumberFormat('es-ES', {
        style: 'currency',
        currency: 'EUR'
    }).format(amount);
};

window.truncateText = function(text, maxLength = 50) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
};