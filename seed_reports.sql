-- Inserción de reportes de prueba para oFraud
USE ofraud;

-- Reportes de Juan (user_id=2)
-- Reporte 1: Phishing bancario
INSERT INTO reports (author_id, category_id, status, is_anonymous, created_at) VALUES
(2, 1, 'pending', 0, NOW());
SET @report_id_1 = LAST_INSERT_ID();

INSERT INTO report_revisions (report_id, version_number, title, description, incident_url, publisher_host, is_anonymous, created_by_user_id, created_at) VALUES
(@report_id_1, 1, 'Sitio de phishing bancario', 'Encontré un sitio web que suplanta a mi banco. Solicita credenciales y números de tarjeta. El diseño es muy similar al sitio real.', 'https://fake-bank-login.com', 'fake-bank-login.com', 0, 2, NOW());

UPDATE reports SET current_revision_id = LAST_INSERT_ID() WHERE id = @report_id_1;

-- Reporte 2: Estafa de inversión (anónimo)
INSERT INTO reports (author_id, category_id, status, is_anonymous, created_at) VALUES
(2, 2, 'pending', 1, NOW());
SET @report_id_2 = LAST_INSERT_ID();

INSERT INTO report_revisions (report_id, version_number, title, description, incident_url, publisher_host, is_anonymous, created_by_user_id, created_at) VALUES
(@report_id_2, 1, 'Estafa de inversión en criptomonedas', 'Prometen duplicar tu inversión en Bitcoin en 24 horas. Es claramente una estafa Ponzi.', 'https://crypto-scam-invest.com', 'crypto-scam-invest.com', 1, 2, NOW());

UPDATE reports SET current_revision_id = LAST_INSERT_ID() WHERE id = @report_id_2;

-- Reportes de María (user_id=3)
-- Reporte 3: Phishing de paquetería
INSERT INTO reports (author_id, category_id, status, is_anonymous, created_at) VALUES
(3, 1, 'pending', 0, NOW());
SET @report_id_3 = LAST_INSERT_ID();

INSERT INTO report_revisions (report_id, version_number, title, description, incident_url, publisher_host, is_anonymous, created_by_user_id, created_at) VALUES
(@report_id_3, 1, 'Correo de phishing de paquetería', 'Recibí un correo que dice que tengo un paquete pendiente y pide información personal para entregarlo.', 'https://fake-delivery-tracking.com', 'fake-delivery-tracking.com', 0, 3, NOW());

UPDATE reports SET current_revision_id = LAST_INSERT_ID() WHERE id = @report_id_3;

-- Reporte 4: Tienda online falsa
INSERT INTO reports (author_id, category_id, status, is_anonymous, created_at) VALUES
(3, 4, 'pending', 0, NOW());
SET @report_id_4 = LAST_INSERT_ID();

INSERT INTO report_revisions (report_id, version_number, title, description, incident_url, publisher_host, is_anonymous, created_by_user_id, created_at) VALUES
(@report_id_4, 1, 'Tienda online falsa', 'Venden productos muy baratos pero nunca llegan. El sitio desapareció después de hacer el pago.', 'https://super-deals-store.com', 'super-deals-store.com', 0, 3, NOW());

UPDATE reports SET current_revision_id = LAST_INSERT_ID() WHERE id = @report_id_4;

-- Reportes de Carlos (user_id=4)
-- Reporte 5: Sorteo falso (anónimo)
INSERT INTO reports (author_id, category_id, status, is_anonymous, created_at) VALUES
(4, 6, 'pending', 1, NOW());
SET @report_id_5 = LAST_INSERT_ID();

INSERT INTO report_revisions (report_id, version_number, title, description, incident_url, publisher_host, is_anonymous, created_by_user_id, created_at) VALUES
(@report_id_5, 1, 'Sorteo falso en redes sociales', 'Prometen un iPhone gratis solo por compartir y dar like. Piden datos personales al final.', 'https://free-iphone-giveaway.com', 'free-iphone-giveaway.com', 1, 4, NOW());

UPDATE reports SET current_revision_id = LAST_INSERT_ID() WHERE id = @report_id_5;

-- Reporte 6: Soporte técnico falso
INSERT INTO reports (author_id, category_id, status, is_anonymous, created_at) VALUES
(4, 5, 'pending', 0, NOW());
SET @report_id_6 = LAST_INSERT_ID();

INSERT INTO report_revisions (report_id, version_number, title, description, incident_url, publisher_host, is_anonymous, created_by_user_id, created_at) VALUES
(@report_id_6, 1, 'Soporte técnico falso', 'Llamada telefónica diciendo que mi computadora tiene virus y ofrecen "ayuda" por un precio.', 'https://fake-tech-support.com', 'fake-tech-support.com', 0, 4, NOW());

UPDATE reports SET current_revision_id = LAST_INSERT_ID() WHERE id = @report_id_6;

-- Reportes de Ana (user_id=5)
-- Reporte 7: Fraude romántico
INSERT INTO reports (author_id, category_id, status, is_anonymous, created_at) VALUES
(5, 7, 'pending', 0, NOW());
SET @report_id_7 = LAST_INSERT_ID();

INSERT INTO report_revisions (report_id, version_number, title, description, incident_url, publisher_host, is_anonymous, created_by_user_id, created_at) VALUES
(@report_id_7, 1, 'Perfil falso en app de citas', 'Conocí a alguien en una app de citas que después de dos semanas pidió dinero para una emergencia médica.', 'https://fake-dating-profile.com', 'dating-app.com', 0, 5, NOW());

UPDATE reports SET current_revision_id = LAST_INSERT_ID() WHERE id = @report_id_7;

-- Reporte 8: Vishing
INSERT INTO reports (author_id, category_id, status, is_anonymous, created_at) VALUES
(5, 8, 'pending', 0, NOW());
SET @report_id_8 = LAST_INSERT_ID();

INSERT INTO report_revisions (report_id, version_number, title, description, incident_url, publisher_host, is_anonymous, created_by_user_id, created_at) VALUES
(@report_id_8, 1, 'Llamada suplantando al banco', 'Me llamaron diciendo que eran del banco y que mi tarjeta había sido bloqueada. Pedían verificar mis datos.', 'tel:+1-800-FAKE-BANK', 'banco-falso.com', 0, 5, NOW());

UPDATE reports SET current_revision_id = LAST_INSERT_ID() WHERE id = @report_id_8;

SELECT '' AS '';
SELECT 'Reportes de prueba creados:' AS '';
SELECT
    r.id,
    CONCAT(u.first_name, ' ', u.last_name) AS autor,
    c.name AS categoria,
    rv.title AS titulo,
    r.status,
    CASE WHEN r.is_anonymous = 1 THEN 'Sí' ELSE 'No' END AS anonimo
FROM reports r
JOIN users u ON r.author_id = u.id
JOIN categories c ON r.category_id = c.id
JOIN report_revisions rv ON r.current_revision_id = rv.id
WHERE r.author_id IN (2, 3, 4, 5)
ORDER BY r.id;
