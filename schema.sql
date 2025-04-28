-- Tabla de datos de docentes
CREATE TABLE tblDocentes (
    id  INT IDENTITY(1,1) PRIMARY KEY,  -- Identificador único, autoincremental
    nombre VARCHAR(100) NOT NULL,      -- Nombre del docente
    apellido VARCHAR(100) NOT NULL,
    cedula VARCHAR(10) NOT NULL,       -- Número de cedula
    celular VARCHAR(20) NULL,           -- Teléfono celular opcional
    correo VARCHAR(255) UNIQUE CHECK (  -- Correo electrónico único
        correo LIKE '_%@_%._%' -- Valida patrón básico: texto@texto.texto
    ),         
    direccion VARCHAR(255) NOT NULL,     -- direccion de domicilio
    especialidad VARCHAR(100) NOT NULL,   --Espcialidad para dar clases
    documentacion_url TEXT NOT NULL,       -- Enlace a curriculum, copia de cedula, etc
    sueldo_mensual NUMERIC(10,2)
  );
  
-- Tabla de datos de asesores
CREATE TABLE tblAsesores (
    id INT IDENTITY(1,1) PRIMARY KEY, -- Identificador único, autoincremental
    nombre VARCHAR(100) NOT NULL,      --Nombre y apellido del asesor
    apellido VARCHAR(100) NOT NULL,
    celular VARCHAR(20) NOT NULL,       --Numero celular del asesor
    correo VARCHAR(255) UNIQUE CHECK (   -- Correo del asesor 
        correo LIKE '_%@_%._%' -- Valida patrón básico: texto@texto.texto
    ),
    saldo_por_cobrar NUMERIC(10,2) DEFAULT 0,  -- Saldo por cobrar de matriculas que no se le han pagado (aumenta con trigger cada vez que se registra un pago de matricula de un alumno)
    cedula VARCHAR(10) NOT NULL      -- Numero de cedula
);

