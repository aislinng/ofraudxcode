-- Inserción de usuarios de prueba para oFraud
-- Todos tienen la misma password: Password123!

USE ofraud;

INSERT INTO users (email, username, first_name, last_name, phone_number, password_hash, password_salt, role, is_blocked, privacy_accepted_at, community_rules_accepted_at, created_at) VALUES
('juan.perez@test.com', 'juanperez', 'Juan', 'Pérez', NULL, '$2b$10$HdJoZfc5T6vtNKNNVdNAMOVAvvwpY1.L4x16OKlqG3wmYOMCuZ/XS', '$2b$10$HdJoZfc5T6vtNKNNVdNAMO', 'user', 0, NOW(), NOW(), NOW()),
('maria.garcia@test.com', 'mariagarcia', 'María', 'García', NULL, '$2b$10$bRwTOeK7zQ7h3G8Q.kl7HelLwMzBibJJ03.NTFQDm1VSiLZeZtY5.', '$2b$10$bRwTOeK7zQ7h3G8Q.kl7He', 'user', 0, NOW(), NOW(), NOW()),
('carlos.lopez@test.com', 'carloslopez', 'Carlos', 'López', NULL, '$2b$10$P30W4GObp3oCJvT0MPqRm.UBmJbBnk4k7gxCjTke6xZGwO61smM5i', '$2b$10$P30W4GObp3oCJvT0MPqRm.', 'user', 0, NOW(), NOW(), NOW()),
('ana.martinez@test.com', 'anamartinez', 'Ana', 'Martínez', NULL, '$2b$10$QkwwwsKCwyAYluXRf6Chu./hddLxGLIuQoiW4thVJh94vC8wL48sm', '$2b$10$QkwwwsKCwyAYluXRf6Chu.', 'user', 0, NOW(), NOW(), NOW())
ON DUPLICATE KEY UPDATE email=email;

SELECT 'Usuarios de prueba creados:' AS '';
SELECT id, email, username, CONCAT(first_name, ' ', last_name) AS nombre, role FROM users WHERE role = 'user';
