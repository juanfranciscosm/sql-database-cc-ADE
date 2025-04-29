  -- Tabla de datos de asesores
CREATE TABLE tblAsesores (
    id INT IDENTITY(1,1) PRIMARY KEY, -- Identificador único, autoincremental
    nombre VARCHAR(30) NOT NULL,      --Nombre y apellido del asesor
    apellido VARCHAR(30) NOT NULL,
    celular VARCHAR(12) NOT NULL,       --Numero celular del asesor
    correo VARCHAR(255) UNIQUE NOT NULL CHECK (   -- Correo del asesor 
        correo LIKE '_%@_%._%' -- Valida patrón básico: texto@texto.texto
    ),
    saldo_por_cobrar NUMERIC(10,2) DEFAULT 0 CHECK (saldo_por_cobrar >= 0),  -- Saldo por cobrar de matriculas que no se le han pagado (aumenta con trigger cada vez que se registra un pago de matricula de un alumno)
    cedula VARCHAR(10) NOT NULL,     -- Numero de cedula
    azureBlob_id VARCHAR(120)             --id de imagen de foto de perfil del personal almacenada en Azure Blob Storage

);


-- Tabla de datos alumnos
CREATE TABLE tblAlumnos (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Identificador único, autoincremental
    nombre VARCHAR(30) NOT NULL,      -- Nombre y Apellido del alumno
    apellido VARCHAR(30) NOT NULL,
    direccion VARCHAR(255) NOT NULL,   --direccion de domicilio del alumno
    celular VARCHAR(12) NOT NULL,      --Numero celular del asesor
    correo VARCHAR(255) UNIQUE NOT NULL CHECK (   -- Correo del asesor 
        correo LIKE '_%@_%._%'          -- Valida patrón básico: texto@texto.texto
    ),
    observaciones TEXT NULL,            --Comentarios internos sobre el alumno
    fecha_inscripcion DATETIME DEFAULT CURRENT_TIMESTAMP, --fecha de inscripcion como alumno
    asesor_id INT NULL,                -- id del asesor encargado del registro (opcional)
    cedula VARCHAR(10),                --numero de cedula del alumno
    azureBlob_id VARCHAR(120),           --id de imagen de foto de perfil de los alumnos almacenada en Azure Blob Storage
    CONSTRAINT FK_asesor_id FOREIGN KEY (asesor_id) REFERENCES tblAsesores(id) --Referencia de la FK asesor_id
);


-- Tabla de Metodos de Pago
CREATE TABLE tblMetodosPago (
    id INT IDENTITY(1,1) PRIMARY KEY,   --Identificador único, autoincremental
    nombre VARCHAR(50) NOT NULL         --Nombre identificador del metodo de pago
);

-- Tabla de Conceptos de Transaccion
CREATE TABLE tblConceptosTransaccion(
    id INT IDENTITY(1,1) PRIMARY KEY,     --Identificador único, autoincremental
    nombre VARCHAR(50),                   --Nombre descriptivo del concepto ej: pago de matricula
    tipo_transaccion VARCHAR(20),         --Identifica el tipo de transaccion (ingreso o egreso)
    CONSTRAINT CK_tipo_transaccion CHECK(tipo_transaccion IN ('ingreso','egreso')) -- Constraint para verificar que solo haya tipo ingreso o egreso.
);

-- Tabla de Sedes
CREATE TABLE tblSedes(
    id INT IDENTITY(1,1) PRIMARY KEY,      --Identificador único, autoincremental     
    nombre VARCHAR(50) NOT NULL,            -- Nombre comercial de la sede
    direccion VARCHAR(255) NOT NULL,       -- Direccion de la sede
    ciudad VARCHAR(255) NOT NULL,           --Ciudad en la que se ubica la sede
    azureBlob_id VARCHAR(120)             --id de imagen de la sede almacenada en Azure Blob Storage
);


-- Tabla de Cuentas Financieras
CREATE TABLE tblCuentasFinancieras (
    id INT IDENTITY(1,1) PRIMARY KEY,   --Identificador único, autoincremental
    nombre VARCHAR(50),                 --Nombre descriptivo de la cuenta fiananciera ej: Caja Chica Guayaquil
    tipo_cuenta VARCHAR(20),            --Nombre del tipo de cuenta financiera pertence
    sede_id INT,                        --id de la sede a la que pertenece la cuenta
    saldo_actual NUMERIC(10,2),         --Saldo disponible en cada cuenta
    CONSTRAINT FK_sede_id FOREIGN KEY (sede_id) REFERENCES tblSedes(id), --Constraint para fk de sede_id
    CONSTRAINT CK_tipo_cuenta CHECK(tipo_cuenta IN ('caja_chica','caja','banco')) --Constraint para verificar el tipo de cuenta ingresado
);


--Tabla de Personal
CREATE TABLE tblPersonal(
    id INT IDENTITY(1,1) PRIMARY KEY,           --Identificador único, autoincremental
    nombre VARCHAR(30) NOT NULL,               -- Nombre y apellido del personal administrativo
    apellido VARCHAR(30) NOT NULL,
    celular VARCHAR(12) NOT NULL,              --Numero de telefono celular del personal
    correo VARCHAR(255) UNIQUE NOT NULL CHECK (   -- Correo del asesor 
        correo LIKE '_%@_%._%'          -- Valida patrón básico: texto@texto.texto
    ),
    direccion VARCHAR(255) NOT NULL,             --Direccion de domicilio del personal
    sueldo_mensual NUMERIC(10,2) NOT NULL,       --Sueldo mensual 
    rol VARCHAR(30) NOT NULL,                    --Rol que desempena en la organizacion
    sede_id INT,                                 --Id de la sede a la que pertenece el personal
    cedula VARCHAR(10),                          --Numero de cedula 
    fecha_vinculacion DATE NOT NULL,             --Fecha de inicio a trabajar (importante para el calculo de pago de salario)           
    especialidad VARCHAR(30),
    CONSTRAINT CK_rol CHECK(rol IN ('secretaria','cajera','auxiliar','presidente','docente')), --Constrain para verificar el rol
    CONSTRAINT FK_sedePersonal_id FOREIGN KEY (sede_id) REFERENCES tblSedes(id),  --Constrain para FK sede_id
    azureBlob_id VARCHAR(120)             --id de imagen de foto de perfil del personal almacenada en Azure Blob Storage
);

--Tabla de Transacciones

CREATE TABLE tblTransacciones (
    id INT IDENTITY(1,1) PRIMARY KEY,                    -- Identificador único autoincremental para cada transacción
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,           -- Fecha y hora de creación de la transacción, se asigna automáticamente
    tipo_transaccion VARCHAR(15) NOT NULL,               -- Tipo de transacción: solo puede ser 'ingreso' o 'egreso'
    monto NUMERIC(10,2) NOT NULL,                        -- Monto de dinero asociado a la transacción, no puede ser negativo
    descripcion VARCHAR(100),                            -- Descripción corta del propósito de la transacción
    observaciones TEXT,                                  -- Observaciones o notas adicionales (texto libre)
    concepto_id INT,                                     -- Relación con el concepto de transacción (por ejemplo, matrícula, inscripción, etc.)
    metodo_pago_id INT,                                  -- Relación con el método de pago usado (efectivo, tarjeta, transferencia, etc.)
    sede_id INT,                                         -- Relación con la sede donde se realiza la transacción
    responsable_id INT,                                  -- Relación con el personal responsable de realizar o registrar la transacción
    pagador_id INT,                                      -- Relación con el alumno que realiza el pago (solo para ingresos)
    cuenta_financiera_id INT,                            -- Relación con la cuenta financiera usada para el movimiento (caja chica, banco, etc.)
    beneficiario_id INT,                                 -- Relación con el personal beneficiario del pago (solo para egresos)
    CONSTRAINT FK_concepto_id FOREIGN KEY(concepto_id) REFERENCES tblConceptosTransaccion(id),
    CONSTRAINT FK_metodo_pago_id FOREIGN KEY(metodo_pago_id) REFERENCES tblMetodosPago(id),
    CONSTRAINT FK_sedeTransaccion_id FOREIGN KEY(sede_id) REFERENCES tblSedes(id),
    CONSTRAINT FK_responsable_id FOREIGN KEY(responsable_id) REFERENCES tblPersonal(id),
    CONSTRAINT FK_pagador_id FOREIGN KEY(pagador_id) REFERENCES tblAlumnos(id),
    CONSTRAINT FK_cuenta_financiera_id FOREIGN KEY(cuenta_financiera_id) REFERENCES tblCuentasFinancieras(id),
    CONSTRAINT FK_beneficiario_id FOREIGN KEY(beneficiario_id) REFERENCES tblPersonal(id),
    CONSTRAINT CK_tipoTransaccion CHECK(tipo_transaccion IN ('ingreso','egreso')),
    CONSTRAINT CK_monto CHECK (monto>= 0),
    CONSTRAINT CK_pagador_beneficiario  CHECK (    -- Restricción que asegura coherencia entre pagador y beneficiario:
                -- Si es 'ingreso' => debe existir pagador y no beneficiario.
                -- Si es 'egreso' => debe existir beneficiario y no pagador.
            (tipo_transaccion = 'ingreso' AND pagador_id IS NOT NULL AND beneficiario_id IS NULL) OR
            (tipo_transaccion = 'egreso' AND pagador_id IS NULL AND beneficiario_id IS NOT NULL)
        )
);

GO   -- Separa el lote anterior para que CREATE TRIGGER sea el primer comando del batch

CREATE TRIGGER TRG_ValidarTransaccionBanco -- Crear un trigger llamado TRG_ValidarTransaccionBanco
ON tblTransacciones                         -- El trigger se activa sobre la tabla tblTransacciones
AFTER INSERT, UPDATE                        -- Se ejecuta después de que ocurran INSERT o UPDATE
AS
BEGIN
    SET NOCOUNT ON;  
    -- Evita que SQL Server devuelva automáticamente mensajes de cuenta de filas afectadas
    -- Esto mejora el rendimiento y evita resultados innecesarios en aplicaciones cliente.

    -- Verificar si se hizo una transacción en una cuenta de tipo Banco
    -- y que el responsable NO sea un Presidente
    IF EXISTS ( 
        SELECT 1  -- Basta con que encuentre una coincidencia para entrar al IF
        FROM inserted i -- Tabla virtual que contiene las filas nuevas o actualizadas
        INNER JOIN tblCuentasFinancieras cf ON i.cuenta_financiera_id = cf.id -- Une con cuentas financieras
        INNER JOIN tblPersonal p ON i.responsable_id = p.id -- Une con el personal (responsable)
        WHERE cf.tipo_cuenta = 'Banco' -- Verifica si la cuenta usada es de tipo 'Banco'
          AND p.rol <> 'Presidente' -- Y si el responsable NO tiene el rol 'Presidente'
    )
    BEGIN
        -- Si la condición anterior se cumple:

        ROLLBACK TRANSACTION;  
        -- Cancela toda la operación de INSERT o UPDATE en tblTransacciones

        RAISERROR('Solo el Presidente puede realizar transacciones con cuentas de tipo Banco.', 16, 1);  
        -- Lanza un error personalizado para notificar que la acción no está permitida
        -- Nivel 16 indica error de usuario (errores que deben corregirse en la aplicación)
        -- El número 1 es un estado arbitrario (puedes usar 1 si no necesitas estados especiales)

        RETURN;
        -- Finaliza la ejecución del trigger para no seguir procesando más instrucciones
    END
END;

GO -- Separa el lote anterior para que CREATE TRIGGER sea el primer comando del batch

-- Crear un trigger que se activa después de insertar una transacción en tblTransacciones
CREATE TRIGGER TRG_SumarSaldoAsesorMatriculacion
ON tblTransacciones
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;  -- Evita que SQL Server devuelva automáticamente el número de filas afectadas

    -- Actualizar el saldo de los asesores solo para las transacciones cuyo concepto sea 'matriculacion'
    UPDATE a
    SET a.saldo_por_cobrar = a.saldo_por_cobrar + i.monto  -- Sumar el monto de la transacción al saldo del asesor
    FROM tblAsesores a
    -- Relacionamos los asesores con los alumnos a través de la tabla tblAlumnos, usando el asesor_id
    INNER JOIN tblAlumnos al ON al.asesor_id = a.id
    -- Obtenemos las transacciones insertadas (nuevas transacciones) desde la tabla 'inserted' (tabla virtual)
    INNER JOIN inserted i ON i.pagador_id = al.id  -- Relacionamos al alumno con la transacción usando pagador_id
    -- Verificamos que el concepto de la transacción sea 'matriculacion'
    INNER JOIN tblConceptosTransaccion c ON i.concepto_id = c.id
    WHERE c.nombre = 'matriculacion';  -- Solo se ejecuta si el concepto de la transacción es 'matriculacion'
END;








--Queries para eliminar elementos de la base de datos por completo

--1
DECLARE @sql NVARCHAR(MAX) = (SELECT STRING_AGG('ALTER TABLE [' + s.name + '].[' + t.name + '] DROP CONSTRAINT [' + c.name + '];', ' ') FROM sys.foreign_keys c JOIN sys.tables t ON c.parent_object_id = t.object_id JOIN sys.schemas s ON t.schema_id = s.schema_id) + ' ' + (SELECT STRING_AGG('ALTER TABLE [' + s.name + '].[' + t.name + '] DROP CONSTRAINT [' + c.name + '];', ' ') FROM sys.objects c JOIN sys.tables t ON c.parent_object_id = t.object_id JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE c.type IN ('PK','UQ','C','D')); EXEC sp_executesql @sql;
--2
DECLARE @sql NVARCHAR(MAX) = (SELECT STRING_AGG('ALTER TABLE [' + s.name + '].[' + t.name + '] DROP CONSTRAINT [' + c.name + '];', ' ') FROM sys.objects c JOIN sys.tables t ON c.parent_object_id = t.object_id JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE c.type IN ('F','PK','UQ','C','D')); EXEC sp_executesql @sql;
--3
DECLARE @sql NVARCHAR(MAX) = (SELECT STRING_AGG('DROP TABLE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];', ' ') FROM sys.tables);
EXEC sp_executesql @sql;


