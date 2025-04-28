-- Tabla de datos de docentes
CREATE TABLE tblDocentes (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Identificador único, autoincremental
    nombre NVARCHAR(100) NOT NULL,      -- Nombre del docente
    apellido NVARCHAR(100) NOT NULL,
    celular NVARCHAR(20) NULL,           -- Teléfono celular opcional
    correo NVARCHAR(255) UNIQUE CHECK (  -- Correo electrónico único
        correo LIKE '_%@_%._%' -- Valida patrón básico: texto@texto.texto
    ),         
    direccion NVARCHAR(255) NOT NULL,     -- direccion de domicilio
    especialidad NVARCHAR(100) NOT NULL,   --Espcialidad para dar clases
    documentacion_url TEXT NOT NULL,       -- Enlace a curriculum, copia de cedula, etc
    sueldo_mensual NUMERIC(10,2)
  );
  

