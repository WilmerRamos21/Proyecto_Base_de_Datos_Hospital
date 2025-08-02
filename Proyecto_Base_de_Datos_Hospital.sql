-- SCHEMA: hospital

-- DROP SCHEMA IF EXISTS hospital ;

-- ==============================
-- Proyecto Final de Bases de Datos
-- Tematica: Hospital
-- ==============================

-- TABLAS

-- Tabla de Roles

CREATE TABLE IF NOT EXISTS roles (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(20) CHECK (nombre_rol IN ('Recepcionista', 'Doctor', 'Farmacia', 'Auditor')) NOT NULL
);

-- Tabla de Usuarios

CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(50) UNIQUE NOT NULL,
    clave VARCHAR(250) NOT NULL,
    rol_id INT REFERENCES roles(id_rol) NOT NULL
);


-- Tabla de Especialidades

CREATE TABLE IF NOT EXISTS especialidades (
    id_especialidad SERIAL PRIMARY KEY,
    nombre_especialidad VARCHAR(100) UNIQUE NOT NULL
 );


-- Tabla de Medicos

CREATE TABLE IF NOT EXISTS medicos (
    id_medico SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    especialidad_id INT REFERENCES especialidades(id_especialidad) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(250) NOT NULL
);


-- Tabla de pacientes

CREATE TABLE IF NOT EXISTS pacientes (
    id_paciente SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero CHAR(1) CHECK (genero IN ('M', 'F')) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(250) NOT NULL,
    contacto_emergencia_nombre VARCHAR(100) NOT NULL,
    contacto_emergencia_telefono VARCHAR(20) NOT NULL,
    historia_clinica TEXT NOT NULL
);


-- Tabla de Citas Medicas

CREATE TABLE IF NOT EXISTS citas_medicas (
    id_cita SERIAL PRIMARY KEY,
    id_paciente INT REFERENCES pacientes(id_paciente) NOT NULL,
    id_medico INT REFERENCES medicos(id_medico) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('Pendiente', 'Atendida', 'Cancelada')) NOT NULL,
    tipo_consulta VARCHAR(20) CHECK (tipo_consulta IN ('General', 'Especialista', 'Emergencia')) NOT NULL
);


-- Tabla de Medicamentos

CREATE TABLE IF NOT EXISTS medicamentos (
    id_medicamento SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    stock_actual INT CHECK (stock_actual >= 0) NOT NULL
);


-- Tabla de Recetas

CREATE TABLE IF NOT EXISTS recetas (
    id_receta SERIAL PRIMARY KEY,
    id_cita INT REFERENCES citas_medicas(id_cita) NOT NULL,
    fecha DATE NOT NULL,
    observaciones TEXT NOT NULL,
    entregada BOOLEAN DEFAULT FALSE NOT NULL 
);


-- Tabla de Detalle Recetas

CREATE TABLE IF NOT EXISTS detalle_receta (
    id_detalle SERIAL PRIMARY KEY,
    id_receta INT REFERENCES recetas(id_receta) NOT NULL,
    id_medicamento INT REFERENCES medicamentos(id_medicamento) NOT NULL,
    dosis VARCHAR(100) NOT NULL,
    frecuencia VARCHAR(100) NOT NULL,
    duracion_dias INT CHECK (duracion_dias > 0) NOT NULL
);


-- Tabla de Tarifas 

CREATE TABLE IF NOT EXISTS tarifas (
    tipo_consulta VARCHAR(20) PRIMARY KEY CHECK (tipo_consulta IN ('General', 'Especialista', 'Emergencia')),
    costo NUMERIC(10, 2) CHECK (costo >= 0) NOT NULL
);


-- Tabla de Facturas

CREATE TABLE IF NOT EXISTS facturas (
    id_factura SERIAL PRIMARY KEY,
    id_cita INT REFERENCES citas_medicas(id_cita) NOT NULL,
    fecha_emision DATE NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    tipo_consulta VARCHAR(20) CHECK (tipo_consulta IN ('General', 'Especialista', 'Emergencia')) NOT NULL
);


-- Tabla de Tratamientos

CREATE TABLE IF NOT EXISTS tratamientos (
    id_tratamiento SERIAL PRIMARY KEY,
    id_paciente INT REFERENCES pacientes(id_paciente) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('Activo', 'Finalizado', 'Suspendido')) NOT NULL
);


-- ==============================
-- REGISTROS
-- ==============================
-- 1. Registro Roles
-- ==============================
INSERT INTO roles (nombre_rol) VALUES
('Recepcionista'),
('Doctor'),
('Farmacia'),
('Auditor');

-- ==============================
-- 2. Registro Usuarios
-- ==============================
INSERT INTO usuarios (nombre_usuario, clave, rol_id) VALUES
('recepcion1', '123456', 1),
('doctor_cvera', 'medico123', 2),
('farmacia1', 'farm@2025', 3),
('auditor_admin', 'audit2025', 4),
('doctor_aparedes', 'neurologia123', 2),
('admin_general', 'admin1234', 4);

-- ==============================
-- 3. Registro Especialidades
-- ==============================
INSERT INTO especialidades (nombre_especialidad) VALUES
('Pediatría'),
('Cardiología'),
('Dermatología'),
('Neurología'),
('Medicina General');

-- ==============================
-- 4. Registro Medicos
-- ==============================
INSERT INTO medicos (nombres, apellidos, especialidad_id, telefono, email) VALUES
('Ana', 'Martínez', 1, '0991234567', 'ana.martinez@hospital.com'),
('Carlos', 'Vera', 2, '0987654321', 'carlos.vera@hospital.com'),
('Luis', 'Gómez', 3, '0976543210', 'luis.gomez@hospital.com'),
('María', 'Paredes', 4, '0961237890', 'maria.paredes@hospital.com'),
('Jorge', 'Ramírez', 5, '0954567890', 'jorge.ramirez@hospital.com');

-- ==============================
-- 5. Registro Pacientes
-- ==============================
INSERT INTO pacientes (nombres, apellidos, fecha_nacimiento, genero, direccion, telefono, email, contacto_emergencia_nombre, contacto_emergencia_telefono, historia_clinica) VALUES
('Lucía', 'Herrera', '1995-04-10', 'F', 'Calle A #123', '0981122334', 'lucia.herrera@gmail.com', 'Pedro Herrera', '0984455667', 'Asma desde la infancia.'),
('Mateo', 'Cueva', '2001-01-25', 'M', 'Av. Central 45', '0999988776', 'mateo.cueva@gmail.com', 'Ana Cueva', '0991239876', 'Historial de migrañas.'),
('Esteban', 'Rojas', '1980-11-15', 'M', 'Calle Sur 12', '0977744112', 'esteban.rojas@gmail.com', 'Luis Rojas', '0968877665', 'Hipertensión leve.'),
('Valentina', 'Silva', '2005-07-02', 'F', 'Barrio Norte 77', '0955544332', 'valen.silva@gmail.com', 'Rosa Silva', '0958887776', 'Sin historial clínico.'),
('Fernanda', 'León', '1990-09-10', 'F', 'Av. del Sol 88', '0967890123', 'fernanda.leon@gmail.com', 'Carlos León', '0992224443', 'Alergia a penicilina.');

-- ==============================
-- 6. Registro Citas Medicas
-- ==============================
INSERT INTO citas_medicas (id_paciente, id_medico, fecha, hora, estado, tipo_consulta) VALUES
(1, 1, '2025-07-20', '10:00', 'Pendiente', 'General'),
(2, 2, '2025-07-21', '11:30', 'Pendiente', 'Especialista'),
(3, 5, '2025-07-18', '09:00', 'Atendida', 'General'),
(4, 3, '2025-07-22', '13:00', 'Cancelada', 'Especialista'),
(5, 4, '2025-07-19', '15:00', 'Atendida', 'Emergencia');

-- ==============================
-- 7. Registro Medicamentos
-- ==============================
INSERT INTO medicamentos (nombre, descripcion, stock_actual) VALUES
('Paracetamol 500mg', 'Analgésico y antipirético', 200),
('Amoxicilina 500mg', 'Antibiótico de amplio espectro', 100),
('Ibuprofeno 400mg', 'Analgésico, antiinflamatorio', 150),
('Omeprazol 20mg', 'Protector gástrico', 80),
('Loratadina 10mg', 'Antihistamínico', 120);

-- ==============================
-- 8. Registro Recetas
-- ==============================
INSERT INTO recetas (id_cita, fecha, observaciones, entregada) VALUES
(3, '2025-07-18', 'Tratamiento para dolor muscular.', TRUE),
(5, '2025-07-19', 'Control de síntomas alérgicos.', FALSE);

-- ==============================
-- 9. Registro Detalle Recetas
-- ==============================
INSERT INTO detalle_receta (id_receta, id_medicamento, dosis, frecuencia, duracion_dias) VALUES
(1, 1, '1 tableta', 'Cada 8 horas', 5),
(1, 4, '1 cápsula', 'Cada 12 horas', 7),
(2, 5, '1 tableta', 'Cada 24 horas', 10);

-- ==============================
-- 10. Registro Tarifa
-- ==============================
INSERT INTO tarifas (tipo_consulta, costo) VALUES
('General', 20.00),
('Especialista', 35.00),
('Emergencia', 50.00);

-- ==============================
-- 11. Registro Facturas
-- ==============================
INSERT INTO facturas (id_cita, fecha_emision, total, tipo_consulta) VALUES
(3, '2025-07-18', 20.00, 'General'),
(5, '2025-07-19', 50.00, 'Emergencia');

-- ==============================
-- 12. Registro Tratamientos
-- ==============================
INSERT INTO tratamientos (id_paciente, descripcion, fecha_inicio, fecha_fin, estado) VALUES
(1, 'Tratamiento respiratorio para asma', '2025-07-01', '2025-07-31', 'Activo'),
(3, 'Control de presión arterial', '2025-06-01', '2025-07-15', 'Finalizado'),
(2, 'Terapia para migraña crónica', '2025-07-10', '2025-08-10', 'Activo');

-- ==============================
-- Procedimientos Almacenados
-- ==============================
-- 	1.	Insertar una cita médica validando que el paciente y el médico existen.

CREATE OR REPLACE PROCEDURE insertar_cita(
	IN p_id_paciente INT,
	IN p_id_medico INT,
	IN p_fecha DATE,
	IN p_hora TIME,
	IN p_estado VARCHAR(20),
	IN p_tipo_consulta VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN 
	-- Validar si paciente existe
	IF NOT EXISTS (
		SELECT 1 FROM pacientes
		WHERE id_paciente = p_id_paciente
		)THEN 
		RAISE EXCEPTION 'Paciente no existe.';
	END IF;

	-- Validar si doctor existe 
	IF NOT EXISTS (
	SELECT 1 FROM medicos
	WHERE id_medico = p_id_medico
	)THEN 
	RAISE EXCEPTION 'Medico no existe.';
	END IF;
	
	-- Insertar cita medica
	INSERT INTO citas_medicas(id_paciente, id_medico, fecha, hora, estado, tipo_consulta)
	VALUES (p_id_paciente, p_id_medico, p_fecha, p_hora, p_estado, p_tipo_consulta);
	
END;
$$;

CALL insertar_cita(1, 2, '2025-08-01', '12:00', 'Pendiente', 'General');
SELECT * FROM citas_medicas;
-- Generacion de reportes por periodo 
-- 2. Mostrar citas por médico en un rango de fechas.

CREATE OR REPLACE PROCEDURE reporte_citas_medicas(
	IN p_id_medico INT,
	IN p_fecha_inicio DATE,
	IN p_fecha_fin DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
	rec RECORD;
BEGIN
	RAISE NOTICE 'Citas del medico % entre % y %: ', p_id_medico, p_fecha_inicio, p_fecha_fin;

	FOR rec IN
		SELECT *
		FROM citas_medicas
		WHERE id_medico = p_id_medico
			AND fecha BETWEEN p_fecha_inicio AND p_fecha_fin
	LOOP
		RAISE NOTICE 'Cita: %, Paciente: %, Fecha: %, Hora: %',
			rec.id_cita, rec.id_paciente, rec.fecha, rec.hora;
	END LOOP;
END;
$$;

CALL reporte_citas_medicas(1, '2025-01-01', '2025-07-20');

-- Actualizaciones masivas por condicion
-- 3.Actualizar estado de tratamientos cuyo fecha_fin ya pasó. 

CREATE OR REPLACE PROCEDURE actualizar_estado_tratamientos()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE tratamientos
    SET estado = 'Finalizado'
    WHERE fecha_fin < CURRENT_DATE
      AND estado != 'Finalizado';

    RAISE NOTICE 'Se actualizaron los tratamientos vencidos a Finalizado.';
END;
$$;

-- Llamada de ejemplo
CALL actualizar_estado_tratamientos();

-- Eliminacion segura
-- 4. Elimina un paciente solo si no tiene citas registradas.

CREATE OR REPLACE PROCEDURE eliminar_paciente_seguro(p_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verificar si el paciente tiene citas médicas
    IF EXISTS (
        SELECT 1 FROM citas_medicas WHERE id_paciente = p_id
    ) THEN
        RAISE EXCEPTION 'No se puede eliminar el paciente: tiene citas registradas.';
    END IF;

    DELETE FROM pacientes WHERE id_paciente = p_id;
    RAISE NOTICE 'Paciente eliminado exitosamente.';
END;
$$;

-- Llamada de ejemplo
CALL eliminar_paciente_seguro(4);




--5.Facturación automática (inserción con validaciones + transacción)
-- Generar factura automáticamente desde una cita si no tiene factura asociada.

CREATE OR REPLACE PROCEDURE generar_factura_automatica(p_id_cita INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tipo_consulta VARCHAR(20);
    v_total NUMERIC(10,2);
    v_existente INT;
BEGIN
    -- Iniciar transacción
    BEGIN
        -- Validar que la cita exista
        IF NOT EXISTS (SELECT 1 FROM citas_medicas WHERE id_cita = p_id_cita) THEN
            RAISE EXCEPTION 'La cita no existe.';
        END IF;

        -- Validar si ya tiene factura
        SELECT COUNT(*) INTO v_existente FROM facturas WHERE id_cita = p_id_cita;
        IF v_existente > 0 THEN
            RAISE EXCEPTION 'La cita ya tiene factura generada.';
        END IF;

        -- Obtener tipo de consulta y costo
        SELECT tipo_consulta INTO v_tipo_consulta FROM citas_medicas WHERE id_cita = p_id_cita;
        SELECT costo INTO v_total FROM tarifas WHERE tipo_consulta = v_tipo_consulta;

        -- Insertar factura
        INSERT INTO facturas (id_cita, fecha_emision, total, tipo_consulta)
        VALUES (p_id_cita, CURRENT_DATE, v_total, v_tipo_consulta);

        RAISE NOTICE 'Factura generada correctamente para la cita % con costo %', p_id_cita, v_total;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error en la generación automática de factura: %', SQLERRM;
    END;
END;
$$;

-- Llamada de ejemplo
CALL generar_factura_automatica(1);

SELECT * FROM citas_medicas;
SELECT * FROM facturas;

-- FUNCIONES 
-- 1. Función para calcular la edad de un paciente (por ID)

-- Tipo: Edad / cálculo de indicadores
-- Devuelve: Entero con la edad actual

CREATE OR REPLACE FUNCTION calcular_edad(p_id_paciente INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_fecha_nacimiento DATE;
    v_edad INT;
BEGIN
    SELECT fecha_nacimiento INTO v_fecha_nacimiento
    FROM pacientes
    WHERE id_paciente = p_id_paciente;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Paciente no encontrado.';
    END IF;

    v_edad := DATE_PART('year', AGE(CURRENT_DATE, v_fecha_nacimiento));

    RETURN v_edad;
END;
$$;

-- Probar el funcionamiento de la funcion
SELECT calcular_edad(1) AS Edad_Paciente;

-- 2. Función para calcular la duración en días de un tratamiento

-- Tipo: Duración / cálculo agregado personalizado
-- Devuelve: Número de días entre fecha inicio y fecha fin

CREATE OR REPLACE FUNCTION duracion_tratamiento(p_id_tratamiento INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_inicio DATE;
    v_fin DATE;
BEGIN
    SELECT fecha_inicio, fecha_fin INTO v_inicio, v_fin
    FROM tratamientos
    WHERE id_tratamiento = p_id_tratamiento;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Tratamiento no encontrado.';
    END IF;

    RETURN v_fin - v_inicio;
END;
$$;

-- Ejemplo de uso:
SELECT duracion_tratamiento(2);


-- 3. Función para verificar si un paciente tiene tratamiento activo o no

-- Tipo: Estado condicional / lógica SQL
-- Devuelve: Texto (‘Activo’, ‘Sin tratamiento activo’)

CREATE OR REPLACE FUNCTION estado_tratamiento_paciente(p_id_paciente INT)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
    v_estado VARCHAR;
BEGIN
    SELECT estado INTO v_estado
    FROM tratamientos
    WHERE id_paciente = p_id_paciente AND estado = 'Activo'
    LIMIT 1;

    IF FOUND THEN
        RETURN 'Activo';
    ELSE
        RETURN 'Sin tratamiento activo';
    END IF;
END;
$$;

-- Ejemplo de uso:
SELECT estado_tratamiento_paciente(2);



-- Triggers 

-- 1. Trigger de Auditoría

-- Objetivo: Registrar en una tabla de log cualquier inserción, actualización o eliminación en la tabla usuarios.
-- Paso 1: Crear tabla de log
CREATE TABLE IF NOT EXISTS log_usuarios (
    id_log SERIAL PRIMARY KEY,
    id_usuario INT,
    accion VARCHAR(10), -- 'INSERT', 'UPDATE', 'DELETE'
    nombre_usuario VARCHAR(50),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Paso 2: Crear función del trigger
CREATE OR REPLACE FUNCTION log_cambios_usuarios()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO log_usuarios(id_usuario, accion, nombre_usuario)
        VALUES (NEW.id_usuario, 'INSERT', NEW.nombre_usuario);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO log_usuarios(id_usuario, accion, nombre_usuario)
        VALUES (NEW.id_usuario, 'UPDATE', NEW.nombre_usuario);
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO log_usuarios(id_usuario, accion, nombre_usuario)
        VALUES (OLD.id_usuario, 'DELETE', OLD.nombre_usuario);
    END IF;
    RETURN NULL;
END;
$$;

-- Paso 3: Asociar el trigger
CREATE TRIGGER tr_log_usuarios
AFTER INSERT OR UPDATE OR DELETE ON usuarios
FOR EACH ROW
EXECUTE FUNCTION log_cambios_usuarios();


-- Ejemplo de uso del trigger
INSERT INTO usuarios(nombre_usuario, clave, rol_id)
VALUES ('recepcionista_0', 'rcp123', 1);
SELECT * FROM log_usuarios;


-- 2. Trigger de control automático de stock

--Objetivo: Disminuir automáticamente el stock del medicamento al registrar un detalle_receta.
-- Crear función del trigger
CREATE OR REPLACE FUNCTION descontar_stock_medicamento()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE medicamentos
    SET stock_actual = stock_actual - 1
    WHERE id_medicamento = NEW.id_medicamento;

    RETURN NEW;
END;
$$;

-- Asociar el trigger
CREATE TRIGGER tr_descontar_stock
AFTER INSERT ON detalle_receta
FOR EACH ROW
EXECUTE FUNCTION descontar_stock_medicamento();

-- Ejemplo de uso del trigger
INSERT INTO recetas (id_cita, fecha, observaciones, entregada) VALUES
(6, '2025-07-10', 'Tratamiento para el dolor de cabeza.', TRUE);

INSERT INTO detalle_receta (id_receta, id_medicamento, dosis, frecuencia, duracion_dias) VALUES
(3, 1, '1 tableta', 'Cada 8 horas', 4);


-- 3. Trigger de notificación simulada

-- Objetivo: Simular una notificación al insertar una nueva cita médica para estado ‘Pendiente’.
-- Crear tabla para registrar notificaciones
CREATE TABLE IF NOT EXISTS notificaciones (
    id_notificacion SERIAL PRIMARY KEY,
    id_cita INT,
    mensaje TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear función del trigger
CREATE OR REPLACE FUNCTION notificar_cita_paciente()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_nombre TEXT;
BEGIN
    IF NEW.estado = 'Pendiente' THEN
        SELECT CONCAT(nombres, ' ', apellidos) INTO v_nombre
        FROM pacientes WHERE id_paciente = NEW.id_paciente;

        INSERT INTO notificaciones(id_cita, mensaje)
        VALUES (
            NEW.id_cita,
            'Se ha agendado una nueva cita para el paciente ' || v_nombre
        );
    END IF;
    RETURN NEW;
END;
$$;

--  Asociar el trigger
CREATE TRIGGER tr_notificacion_cita
AFTER INSERT ON citas_medicas
FOR EACH ROW
EXECUTE FUNCTION notificar_cita_paciente();

-- Ejemplo de funcionamiento del trigger
INSERT INTO citas_medicas (id_paciente, id_medico, fecha, hora, estado, tipo_consulta) VALUES
(2, 2, '2025-01-03', '13:00:40', 'Pendiente', 'General');

SELECT * FROM notificaciones;


-- Listar todos los triggers creados 
SELECT t.tgname AS nombre_trigger,
       c.relname AS tabla,
       p.proname AS funcion
FROM pg_trigger t
JOIN pg_class c ON t.tgrelid = c.oid
JOIN pg_proc p ON t.tgfoid = p.oid
WHERE NOT t.tgisinternal
ORDER BY c.relname, t.tgname;

-- Indices 

-- Índices para mejorar búsquedas por filtros
CREATE INDEX idx_paciente_genero ON pacientes(genero);
CREATE INDEX idx_citas_estado ON citas_medicas(estado);
CREATE INDEX idx_citas_fecha ON citas_medicas(fecha);
CREATE INDEX idx_tratamientos_estado ON tratamientos(estado);

-- Índices en claves foráneas (optimizan JOINs)
CREATE INDEX idx_citas_paciente ON citas_medicas(id_paciente);
CREATE INDEX idx_citas_medico ON citas_medicas(id_medico);
CREATE INDEX idx_recetas_cita ON recetas(id_cita);
CREATE INDEX idx_detalle_medicamento ON detalle_receta(id_medicamento);


--  2. ÍNDICES COMPUESTOS
-- Búsqueda de citas por médico y rango de fecha
CREATE INDEX idx_citas_medico_fecha ON citas_medicas(id_medico, fecha);

-- Búsqueda de tratamientos por paciente y estado
CREATE INDEX idx_tratamientos_paciente_estado ON tratamientos(id_paciente, estado);

-- Búsqueda de citas por tipo y estado (uso frecuente en reportes)
CREATE INDEX idx_citas_tipo_estado ON citas_medicas(tipo_consulta, estado);

-- Listar los indices creados

SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM 
    pg_indexes
ORDER BY 
    tablename, indexname;

-- 3. ANÁLISIS DE RENDIMIENTO CON EXPLAIN
DROP INDEX idx_citas_medico_fecha;
-- Antes de aplicar índices
EXPLAIN ANALYZE
SELECT * FROM citas_medicas
WHERE id_medico = 2 AND fecha BETWEEN '2025-07-01' AND '2025-07-31';

-- Después de crear índice compuesto:
-- Ya creado anteriormente:
-- CREATE INDEX idx_citas_medico_fecha ON citas_medicas(id_medico, fecha);

EXPLAIN ANALYZE
SELECT * FROM citas_medicas
WHERE id_medico = 2 AND fecha BETWEEN '2025-07-01' AND '2025-07-31';


-- 4. SIMULACIÓN DE CARGA (500 registros)
-- Insertar registros simulados como ejemplo para citas_medicas
DO $$
DECLARE
    i INT := 1;
    rand_paciente INT;
    rand_medico INT;
    rand_tipo TEXT;
    rand_estado TEXT;
    tipos TEXT[] := ARRAY['General', 'Especialista', 'Emergencia'];
    estados TEXT[] := ARRAY['Pendiente', 'Atendida', 'Cancelada'];
BEGIN
    WHILE i <= 500 LOOP
        rand_paciente := (1 + floor(random() * 5))::INT;
        rand_medico := (1 + floor(random() * 5))::INT;
        rand_tipo := tipos[(1 + floor(random() * 3))::INT];
        rand_estado := estados[(1 + floor(random() * 3))::INT];

        INSERT INTO citas_medicas(id_paciente, id_medico, fecha, hora, estado, tipo_consulta)
        VALUES (
            rand_paciente,
            rand_medico,
            CURRENT_DATE - (floor(random() * 365))::INT,
            TO_CHAR(TIME '08:00:00' + (random() * interval '8 hours'), 'HH24:MI:SS')::TIME,
            rand_estado,
            rand_tipo
        );
        i := i + 1;
    END LOOP;
END $$;

-- Medición de rendimiento con índice

-- Se realizo varias ejecuciones de la misma consulta con EXPLAIN ANALYZE:
EXPLAIN ANALYZE
SELECT * FROM citas_medicas
WHERE tipo_consulta = 'General' AND estado = 'Pendiente';

-- ===========================================================
-- 1. Creación de Roles Personalizados
-- Rol administrador (superusuario)
CREATE ROLE administrador LOGIN PASSWORD 'admin123' SUPERUSER;

-- Rol auditor
CREATE ROLE auditor LOGIN PASSWORD 'auditor123';

-- Rol operador
CREATE ROLE operador LOGIN PASSWORD 'operador123';

-- Rol cliente (solo lectura)
CREATE ROLE cliente LOGIN PASSWORD 'cliente123';

-- Rol proveedor (inserta y actualiza)
CREATE ROLE proveedor LOGIN PASSWORD 'proveedor123';

-- Rol usuario_final (solo acceso básico)
CREATE ROLE usuario_final LOGIN PASSWORD 'usuario123';

-- 2. Gestión de Privilegios con GRANT / REVOKE
-- Dar privilegios de solo lectura al auditor
GRANT SELECT ON ALL TABLES IN SCHEMA public TO auditor;

-- Permitir al operador hacer SELECT, INSERT y UPDATE
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO operador;

-- Permitir al cliente solo ver datos
GRANT SELECT ON pacientes, tratamientos TO cliente;

-- Revocar UPDATE al cliente por seguridad
REVOKE UPDATE ON tratamientos FROM cliente;

-- Consultar los roles creados
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles;

-- 3. Encriptación con pgcrypto (SHA, MD5, AES)
-- Primero, asegúrate de tener la extensión instalada:
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- MD5 / SHA256 (demostrativo):
-- MD5 hash
SELECT md5('contraseña123');

-- SHA256
SELECT encode(digest('contraseña123', 'sha256'), 'hex');

-- ES cifrado y descifrado (simulado):
-- Cifrar un texto
SELECT pgp_sym_encrypt('texto_confidencial', 'clave_secreta');

-- Descifrar el texto
SELECT pgp_sym_decrypt(pgp_sym_encrypt('texto_confidencial', 'clave_secreta'), 'clave_secreta');

-- 4. Simulación de conexión SSL/TLS
-- En local, se puede simular que el servidor esté preparado para SSL. En PostgreSQL:
-- En postgresql.conf, habilitar: 
ssl = on
ssl_cert_file = 'server.crt'
ssl_key_file = 'server.key'

-- Luego de modificar el archivo postgsql.conf se debe reiniciar PostgreSQL
SELECT pg_reload_conf();

-- Verificar si el servicio SSL esta corriendo
SELECT ssl FROM pg_stat_ssl WHERE pid = pg_backend_pid();

-- Mostrar si esta encendido el servicio de SSL
SHOW ssl;


-- Simula la conexión usando un cliente que soporte SSL (como DBeaver o psql con sslmode=require).
-- 5. Registro de intentos fallidos o sospechosos (simulado)
-- Crea una tabla para registrar intentos inválidos:
CREATE TABLE log_intentos (
    id SERIAL PRIMARY KEY,
    usuario TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_origen TEXT,
    mensaje TEXT
);
-- Luego, simula un trigger para registrar el intento:
INSERT INTO log_intentos (usuario, ip_origen, mensaje)
VALUES ('usuario_falso', '192.168.0.105', 'Intento fallido de acceso');

SELECT * FROM log_intentos;

-- 6. Validaciones con Expresiones Regulares
-- Ejemplo: Validar email antes de insertar un paciente.
CREATE OR REPLACE FUNCTION validaremail(correo VARCHAR(250))
RETURNS BOOLEAN AS $$
BEGIN
    IF correo ~* '^[A-Za-z0-9.%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$' THEN
        RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'Correo inválido';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Uso:
SELECT validaremail('lucia.herrera@gmail.com'); -- OK

SELECT validaremail('correo#incorrecto'); -- ERROR

-- 7. Revisión del historial de roles y privilegios activos
-- Consulta roles asignados:

-- Roles del sistema en bash Linux/Mac
\du

-- Roles asignados a un usuario específico
SELECT * FROM pg_roles WHERE rolname = 'auditor';

-- Privilegios activos
SELECT grantee, privilege_type, table_name
FROM information_schema.role_table_grants
WHERE grantee IN ('auditor', 'operador', 'cliente');


-- AUDITORIA
-- 1. Tabla log_acciones
CREATE TABLE IF NOT EXISTS log_acciones (
    id SERIAL PRIMARY KEY,
    usuario TEXT,
    rol_actual TEXT,
    ip_origen TEXT,
    terminal TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    accion TEXT,
    tabla_afectada TEXT,
    id_afectado INTEGER,
    transaccion TEXT,
    hash_anterior TEXT
);
--  2. Trigger de auditoría genérico
--  2.1. Función de auditoría
CREATE OR REPLACE FUNCTION fn_log_accion()
RETURNS TRIGGER AS $$
DECLARE
    v_usuario TEXT := current_user;
    v_rol TEXT := session_user;
    v_ip TEXT := inet_client_addr()::TEXT;
    v_terminal TEXT := 'localhost';
    v_accion TEXT;
    v_hash TEXT := NULL;
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_accion := 'INSERT';

    ELSIF TG_OP = 'UPDATE' THEN
        v_accion := 'UPDATE';
        v_hash := encode(digest(ROW(OLD.*)::TEXT, 'sha256'), 'hex');

    ELSIF TG_OP = 'DELETE' THEN
        v_accion := 'DELETE';
        v_hash := encode(digest(ROW(OLD.*)::TEXT, 'sha256'), 'hex');
    END IF;

    -- Insertar log
    INSERT INTO log_acciones (
        usuario, rol_actual, ip_origen, terminal,
        accion, tabla_afectada, id_afectado, transaccion, hash_anterior
    )
    VALUES (
        v_usuario, v_rol, v_ip, v_terminal,
        v_accion, TG_TABLE_NAME, NULL, NULL, v_hash
    );

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

--  2.2. Aplicar triggers a tablas clave
-- Para la tabla pacientes:
CREATE OR REPLACE TRIGGER trg_audit_pacientes_insert
AFTER INSERT ON pacientes
FOR EACH ROW EXECUTE FUNCTION fn_log_accion();

CREATE OR REPLACE TRIGGER trg_audit_pacientes_update
AFTER UPDATE ON pacientes
FOR EACH ROW EXECUTE FUNCTION fn_log_accion();

CREATE OR REPLACE TRIGGER trg_audit_pacientes_delete
AFTER DELETE ON pacientes
FOR EACH ROW EXECUTE FUNCTION fn_log_accion();
-- Puedes repetir el mismo patrón para otras tablas: tratamientos, facturas, etc.
-- Para la tabla facturas:
CREATE OR REPLACE TRIGGER trg_audit_facturas_insert
AFTER INSERT ON facturas
FOR EACH ROW EXECUTE FUNCTION fn_log_accion();

CREATE OR REPLACE TRIGGER trg_audit_facturas_update
AFTER UPDATE ON facturas
FOR EACH ROW EXECUTE FUNCTION fn_log_accion();

CREATE OR REPLACE TRIGGER trg_audit_facturas_delete
AFTER DELETE ON facturas
FOR EACH ROW EXECUTE FUNCTION fn_log_accion();

-- Para la tabla tratamientos:
CREATE OR REPLACE TRIGGER trg_audit_tratamientos_insert
AFTER INSERT ON tratamientos
FOR EACH ROW EXECUTE FUNCTION fn_log_accion();

CREATE OR REPLACE TRIGGER trg_audit_tratamientos_update
AFTER UPDATE ON tratamientos
FOR EACH ROW EXECUTE FUNCTION fn_log_accion();

CREATE OR REPLACE TRIGGER trg_audit_tratamientos_delete
AFTER DELETE ON tratamientos
FOR EACH ROW EXECUTE FUNCTION fn_log_accion();

-- Verificar los procesos ejecutados consultando la tabla centralizada log_acciones
SELECT * FROM log_acciones;

--  3. Control de versiones (Hash de datos anteriores)
-- Ya está incluido en la columna hash_anterior. Esto te permite verificar si alguien modificó 
-- registros sensibles (por ejemplo, facturas o tratamientos) comparando los OLD con los NEW.

--  4. Reportes por usuario, acción, módulo o fecha
-- Acciones de un usuario específico
SELECT * FROM log_acciones WHERE usuario = 'auditor';

-- Acciones por fecha
SELECT * FROM log_acciones WHERE fecha::DATE = CURRENT_DATE;

-- Acciones sobre una tabla específica
SELECT * FROM log_acciones WHERE tabla_afectada = 'consultas';

-- Todas las operaciones de tipo DELETE
SELECT * FROM log_acciones WHERE accion = 'DELETE';



-- 1. Simulación de SQL Injection
-- Simula un ataque como este:
SELECT * FROM usuarios WHERE nombre_usuario = 'admin' AND clave = '' OR '1'='1';

-- Resultado esperado (vulnerable): El atacante accede sin necesidad de credenciales válidas.

-- Simulación de formulario (en pseudocódigo):
-- PYTHON --
usuario = input("Usuario: ")  # admin
clave = input("Contraseña: ")  # ' OR '1'='1

consulta = f"SELECT * FROM usuarios WHERE usuario = '{usuario}' AND contraseña = '{clave}'"

--  2. Prevención con consultas preparadas
-- En PostgreSQL o con psycopg2 (Python):
cursor.execute("SELECT * FROM usuarios WHERE usuario = %s AND contraseña = %s", (usuario, clave))

-- Esto evita que los valores de entrada se interpreten como código SQL.

-- 3. Validaciones previas y políticas
-- Implementar:
-- Expresiones regulares para restringir caracteres especiales.
-- Vistas que solo expongan columnas necesarias.
-- Procedimientos almacenados con parámetros validados internamente.

-- Ejemplo de validación:
CREATE OR REPLACE FUNCTION validar_usuario(p_usuario TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  IF p_usuario ~ '^[a-zA-Z0-9]+$' THEN
    RETURN TRUE;
  ELSE
    RAISE EXCEPTION 'Usuario contiene caracteres inválidos.';
  END IF;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM usuarios;
SELECT validar_usuario('@drian1');

-- Monitoreo y Rendimiento

-- 1. Consulta del tamaño de tablas e índices
-- Tamaño total de la base de datos
SELECT pg_size_pretty(pg_database_size('ssl_test'));

-- Tamaño de cada tabla
SELECT relname AS tabla, pg_size_pretty(pg_total_relation_size(relid)) AS tamaño
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- 2. Control de crecimiento por semana
-- Asumiendo que existe un campo fecha_creacion:

AlTER TABLE pacientes 
ADD COLUMN fecha_creacion TIMESTAMP DEFAULT now();

SELECT date_trunc('week', fecha_creacion) AS semana, COUNT(*) AS registros
FROM pacientes
GROUP BY semana
ORDER BY semana DESC;


-- 3. Evaluar consultas lentas:
EXPLAIN ANALYZE SELECT FROM pacientes WHERE apellidos = 'Herrera';

-- 4. Registro del uso de funciones y procedimientos
-- Revisa el catálogo pg_stat_user_functions:
SELECT funcname, calls, total_time
FROM pg_stat_user_functions
ORDER BY total_time DESC;

-- Usa pg_stat_statements para monitorear uso general:
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Visualizar el archivo de configuracion
SHOW config_file;

-- Mostrar las librerias 
SHOW shared_preload_libraries;

-- Mirar las pg_stat_statements de monitoreo
SELECT query, calls, total_exec_time
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 5;

-- 1. Cifrado de Datos Sensibles (pgcrypto)
-- Habilitar pgcrypto

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Ideal para contraseñas (no se descifran, solo se comparan).
-- Almacenamiento (usando SHA-256)
INSERT INTO usuarios (nombre_usuario, clave, rol_id)
VALUES ('recepcion_1', digest('clave123', 'sha256'),1);

-- Verificación
SELECT * FROM usuarios 
WHERE nombre_usuario = 'recepcion_1';

-- Cifrado reversible (AES)

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Cifrar correo electrónico con AES
INSERT INTO pacientes 
(nombres, apellidos, fecha_nacimiento, genero, direccion, telefono, email, contacto_emergencia_nombre, contacto_emergencia_telefono, historia_clinica) 
VALUES
('Juan', 'Herrera', '1995-04-10', 'M', 'Calle A #123', '0981122334', 
 pgp_sym_encrypt('juan.herrera@mail.com'::text, 'mi_clave_segura'::text), 
 'Pedro Herrera', '0984455667', 'Asma desde la infancia.');

-- Verificar si se cifro el correo electronico
SELECT * FROM pacientes;

-- Cifrar manualmente y descifrar en la misma consulta
SELECT nombres, apellidos, pgp_sym_decrypt(pgp_sym_encrypt('juan.herrera@mail.com'::text, 'clave_segura'::text), 'clave_segura') AS email
FROM pacientes
WHERE id_paciente = 6;


-- 2. Simulación de Anonimización y Enmascaramiento
-- Mostrar la IP del cliente
-- ============================
SELECT inet_client_addr();


-- ============================
-- Anonimización (irreversible)
-- Reemplazo total
UPDATE pacientes
SET nombres = 'Paciente_' || id;

-- Eliminación de campos sensibles
UPDATE pacientes
SET email = NULL, direccion = NULL;

-- Enmascaramiento (reversible, solo para visualización)
-- Mostrar solo parte del correo
SELECT CONCAT(SUBSTRING(email FROM 1 FOR 3), '@.com') AS email_masked
FROM pacientes;


-- 3. Reglas de Negocio con Integridad Lógica

-- Usa funciones y procedimientos para garantizar integridad 
-- que no se puede cubrir solo con restricciones CHECK o FOREIGN KEY.
-- Ejemplo: No permitir duplicar citas con el mismo médico el mismo día
CREATE OR REPLACE FUNCTION validar_cita(p_medico INT, p_fecha DATE)
RETURNS BOOLEAN AS $$
DECLARE
  existe INT;
BEGIN
  SELECT COUNT(*) INTO existe
  FROM citas
  WHERE id_medico = p_medico AND fecha = p_fecha;

  IF existe > 0 THEN
    RAISE EXCEPTION 'El médico ya tiene una cita ese día.';
  END IF;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Edad mínima para registros (e.g., mayores de 18):
CREATE OR REPLACE FUNCTION validar_edad(p_fecha_nacimiento DATE)
RETURNS BOOLEAN AS $$
BEGIN
  IF age(p_fecha_nacimiento) < INTERVAL '18 years' THEN
    RAISE EXCEPTION 'Solo se permiten mayores de 18 años.';
  END IF;
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Validar formato de correo con expresión regular:
CREATE OR REPLACE FUNCTION validar_email(p_email TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  IF pemail ~* '^[A-Za-z0-9.%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}$' THEN
    RETURN TRUE;
  ELSE
    RAISE EXCEPTION 'Email inválido.';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Simulación de Perfiles Profesionales en la Base de Datos
-- ‍1. Administrador de Base de Datos (DBA)

-- Funciones principales:
-- Mantenimiento de índices
-- Respaldos y restauraciones
-- Tareas programadas
-- Monitoreo del sistema

-- Ejemplos prácticos:
-- Crear índice para acelerar búsqueda
CREATE INDEX idx_pacientes_nombre ON pacientes(nombres);

-- Ver estadísticas de uso de disco
SELECT relname AS tabla, pg_size_pretty(pg_total_relation_size(relid)) AS tamaño
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- Ver tamaño y uso de índices
SELECT * FROM pg_stat_user_indexes;
-- Automatización y respaldo: se evidencia mediante script pg_dump, cron (Linux), o pgAgent.

-- 2. Arquitecto de Base de Datos
-- Funciones principales:
-- Diseño lógico y físico (MER, MR)
-- Definición de estándares (nombres, tipos, claves)
-- Modularidad y escalabilidad
-- Verificación de integridad

-- Buenas prácticas:
-- Uso de tipos de datos adecuados (VARCHAR(100) en lugar de TEXT)
-- Claves foráneas y primarias correctamente definidas
-- Diagramas de entidad-relación documentados
-- Normalización a 3FN

-- Verificacion de integridad
-- Verificar claves foráneas
SELECT conname, conrelid::regclass AS tabla, confrelid::regclass AS referencia
FROM pg_constraint
WHERE contype = 'f';

-- 3. Oficial de Seguridad de Base de Datos

-- Funciones principales:
-- Crear roles y asignar privilegios
-- Revisar logs de actividad
-- Proteger datos sensibles
-- Simular y mitigar ataques

-- Roles y privilegios:
-- Crear roles
CREATE ROLE auditor NOLOGIN; -- Ya esta creado
CREATE ROLE medico LOGIN PASSWORD 'medico123';

-- Asignar permisos
GRANT SELECT ON pacientes TO auditor; 
GRANT SELECT, INSERT, UPDATE ON tratamientos TO medico;

-- Registro de actividades (log_statement en postgresql.conf):
log_statement = 'all'  -- para auditar cada consulta

-- Simulación SQL Injection y solución:
-- Simulación insegura:
SELECT * FROM usuarios WHERE nombre_usuario = 'admin' AND clave = ' ' OR '1'='1';

-- Solución: consulta preparada
PREPARE login(text, text) AS
SELECT * FROM usuarios WHERE nombre_usuario = $1 AND clave = digest($2, 'sha256');
EXECUTE login('admin_general', 'admin1234');
SELECT * FROM usuarios;

-- 4. Desarrollador de Consultas
-- Funciones principales:
-- Crear vistas optimizadas
-- Procedimientos y funciones reutilizables
-- Generar reportes dinámicos

-- Vista para reportes:
CREATE OR REPLACE VIEW vista_resumen_citas AS
SELECT m.nombres AS medico, COUNT(*) AS total_citas
FROM citas_medicas c
JOIN medicos m ON c.id_medico = m.id_medico
GROUP BY m.nombres;

SELECT * FROM vista_resumen_citas;

-- Procedimiento reutilizable:
CREATE OR REPLACE FUNCTION total_pacientes_rango(fecha1 DATE, fecha2 DATE)
RETURNS INT AS $$
DECLARE
  total INT;
BEGIN
  SELECT COUNT(*) INTO total
  FROM pacientes
  WHERE fecha_creacion BETWEEN fecha1 AND fecha2;
  RETURN total;
END;
$$ LANGUAGE plpgsql;

SELECT total_pacientes_rango('2025-01-01', '2025-08-03');

-- 5. Usuario Final
-- Funciones principales:
-- Consultas básicas
-- Acceso limitado a vistas controladas
-- No tiene acceso directo a las tablas

-- Acceso seguro:
-- Crear usuario final
CREATE ROLE recepcionista LOGIN PASSWORD 'recepcion123';

-- Dar acceso solo a vistas
GRANT SELECT ON vista_resumen_citas TO recepcionista;

-- El usuario puede ejecutar:
SELECT * FROM vista_resumen_citas;

-- Pero no puede ver ni modificar la tabla original citas.