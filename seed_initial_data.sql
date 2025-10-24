-- Script de inserción inicial de datos para oFraud
-- Base de datos: ofraud
-- Inserta: 1 admin + categorías básicas

USE ofraud;

-- =====================================================
-- 1. CREAR USUARIO ADMINISTRADOR
-- =====================================================
-- Email: admin@ofraud.com
-- Password: Admin123!
-- Bcrypt hash de "Admin123!" con salt rounds=10

INSERT INTO users (
    email,
    username,
    first_name,
    last_name,
    phone_number,
    password_hash,
    password_salt,
    role,
    is_blocked,
    privacy_accepted_at,
    community_rules_accepted_at,
    created_at
) VALUES (
    'admin@ofraud.com',
    'admin',
    'Administrador',
    'Sistema',
    NULL,
    '$2b$10$otBgBPXc..OBCZ6UWt/lBu2tmMZmFCshuE9gONuQewiiosPGyuANe',
    '$2b$10$otBgBPXc..OBCZ6UWt/lBu',
    'admin',
    0,
    NOW(),
    NOW(),
    NOW()
) ON DUPLICATE KEY UPDATE email=email;

-- =====================================================
-- 2. INSERTAR CATEGORÍAS DE FRAUDE
-- =====================================================

INSERT INTO categories (name, slug, description, is_active, created_at) VALUES
(
    'Phishing',
    'phishing',
    'Intentos de robo de información personal o credenciales mediante sitios web, correos o mensajes falsos que suplantan entidades legítimas.',
    1,
    NOW()
),
(
    'Estafa de inversión',
    'estafa-inversion',
    'Esquemas fraudulentos que prometen ganancias garantizadas o retornos irreales en inversiones, criptomonedas, bolsa o negocios piramidales.',
    1,
    NOW()
),
(
    'Suplantación de identidad',
    'suplantacion-identidad',
    'Uso no autorizado de datos personales, documentos o identidad de otra persona para cometer fraudes o delitos.',
    1,
    NOW()
),
(
    'Tienda online falsa',
    'tienda-online-falsa',
    'Sitios de comercio electrónico fraudulentos que no entregan productos, venden réplicas o desaparecen tras recibir el pago.',
    1,
    NOW()
),
(
    'Soporte técnico falso',
    'soporte-tecnico-falso',
    'Personas que se hacen pasar por soporte técnico de empresas conocidas para obtener acceso remoto a dispositivos o cobrar servicios inexistentes.',
    1,
    NOW()
),
(
    'Sorteos y premios falsos',
    'sorteos-premios-falsos',
    'Notificaciones de premios o sorteos ganados que requieren pago de impuestos, envío de datos personales o llamadas a números premium.',
    1,
    NOW()
),
(
    'Fraude romántico',
    'fraude-romantico',
    'Estafadores que crean perfiles falsos en redes sociales o apps de citas para establecer relaciones y posteriormente solicitar dinero.',
    1,
    NOW()
),
(
    'Vishing (llamadas)',
    'vishing',
    'Llamadas telefónicas fraudulentas que suplantan bancos, autoridades o empresas para obtener información confidencial o dinero.',
    1,
    NOW()
),
(
    'Smishing (SMS)',
    'smishing',
    'Mensajes de texto fraudulentos con links maliciosos o solicitudes de información que suplantan entidades bancarias, paqueterías o servicios.',
    1,
    NOW()
),
(
    'Fraude laboral',
    'fraude-laboral',
    'Ofertas de trabajo falsas que solicitan pagos por capacitación, materiales o servicios antes de comenzar, o esquemas de trabajo desde casa fraudulentos.',
    1,
    NOW()
),
(
    'Otro tipo de fraude',
    'otro-fraude',
    'Fraudes que no encajan en las categorías anteriores o combinan múltiples técnicas de engaño.',
    1,
    NOW()
)
ON DUPLICATE KEY UPDATE name=name;

-- =====================================================
-- 3. VERIFICACIÓN
-- =====================================================

SELECT 'Usuario admin creado:' AS '';
SELECT id, email, username, role FROM users WHERE role = 'admin';

SELECT '' AS '';
SELECT 'Categorías insertadas:' AS '';
SELECT id, name, slug, is_active FROM categories ORDER BY id;

SELECT '' AS '';
SELECT CONCAT('Total de categorías: ', COUNT(*)) AS resumen FROM categories;
