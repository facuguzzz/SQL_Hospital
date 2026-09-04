USE hospital_unidad
GO

--CREATE TABLE Medico (
--	id_medico INT IDENTITY,
--	nombre VARCHAR(50),
--	apellido VARCHAR(50),
--	matricula VARCHAR(100),
--	telefono NVARCHAR(20),
--	id_especialidad INT NOT NULL,
--	CONSTRAINT fk_medico_especialidad
--		FOREIGN KEY (id_especialidad)
--		REFERENCES Especialidad (id_especialidad)
	
--)
--GO

ALTER TABLE Medico
ALTER COLUMN nombre VARCHAR(50) NOT NULL;
GO

ALTER TABLE Medico
ALTER COLUMN apellido VARCHAR(50) NOT NULL;
GO

ALTER TABLE Medico
ALTER COLUMN matricula VARCHAR(50) NOT NULL;
GO

ALTER TABLE Medico
ALTER COLUMN telefono NVARCHAR(20) NOT NULL;
GO

ALTER TABLE Medico
ADD CONSTRAINT unq_nombre_apellido_telefono
UNIQUE (nombre, apellido, telefono)

ALTER TABLE Medico
ADD CONSTRAINT unq_matricula 
UNIQUE (matricula)

EXEC sp_helpconstraint 'Medico';

EXEC sp_rename 'unq_matricula', 'unq_medico_matricula', 'OBJECT'
EXEC sp_rename 'unq_nombre_apellido_telefono', 'unq_medico_nombre_apellido_telefono', 'OBJECT'




--CREATE TABLE Obra_Social (
--	id_obra INT IDENTITY,
--	nombre VARCHAR(50),
--	categoria VARCHAR(50)
--	CONSTRAINT pk_obrasocial
--		PRIMARY KEY (id_obra)
--)
--GO

ALTER TABLE Obra_Social 
ALTER COLUMN nombre VARCHAR(50) NOT NULL
GO

ALTER TABLE Obra_Social
ALTER COLUMN categoria VARCHAR(50) NOT NULL
GO

ALTER TABLE Obra_Social
ADD CONSTRAINT unq_nombre UNIQUE (nombre)



--CREATE TABLE Enfermedad (
--	id_enfermedad INT IDENTITY(1,1),
--	nombre VARCHAR(50),
--	descripcion VARCHAR(50),
--	CONSTRAINT pk_enfermedad
--		PRIMARY KEY (id_enfermedad)
--)
--GO

ALTER TABLE Enfermedad
ALTER COLUMN nombre VARCHAR(50) NOT NULL
GO

ALTER TABLE Enfermedad
ALTER COLUMN descripcion VARCHAR(50) NOT NULL
GO

ALTER TABLE Enfermedad
ADD CONSTRAINT unq_nombre UNIQUE (nombre)


SELECT SESSIONPROPERTY('DATEFORMAT') as FormatoActual

DBCC USEROPTIONS