CREATE DATABASE hospital_unidad
GO

USE hospital_unidad
GO

CREATE TABLE Especialidad (
	id_especialidad INT IDENTITY,
	nombre VARCHAR(20) NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	CONSTRAINT pk_empleados
		PRIMARY KEY (id_especialidad)
)
GO

CREATE TABLE Medico (
	id_medico INT IDENTITY,
	nombre VARCHAR(50),
	apellido VARCHAR(50),
	matricula VARCHAR(100),
	telefono NVARCHAR(20),
	id_especialidad INT NOT NULL,
	CONSTRAINT fk_medico_especialidad
		FOREIGN KEY (id_especialidad)
		REFERENCES Especialidad (id_especialidad)
	
	
)
GO

ALTER TABLE Medico
ADD CONSTRAINT pk_medico 
PRIMARY KEY (id_medico)
GO

CREATE TABLE Obra_Social (
	id_obra INT IDENTITY,
	nombre VARCHAR(50),
	categoria VARCHAR(50)
	CONSTRAINT pk_obrasocial
		PRIMARY KEY (id_obra)
)
GO

CREATE TABLE Enfermedad (
	id_enfermedad INT IDENTITY(1,1),
	nombre VARCHAR(50),
	descripcion VARCHAR(50),
	CONSTRAINT pk_enfermedad
		PRIMARY KEY (id_enfermedad)
)
GO

CREATE TABLE Informacion_Medica (
	id_informacion_medica INT IDENTITY(1,1),
	discapacidad VARCHAR(50) NULL,
	tipo_sangre NVARCHAR(50) NULL,
	id_enfermedad INT NULL,
	CONSTRAINT pk_informacion_medica
		PRIMARY KEY (id_informacion_medica),
	CONSTRAINT kf_enfermedad
		FOREIGN KEY (id_enfermedad)
		REFERENCES Enfermedad (id_enfermedad)
)
GO

EXEC sp_rename 'kf_enfermedad','fk_informacionMedica_enfermedad','OBJECT'
GO

CREATE TABLE Paciente (
	id_paciente INT IDENTITY(1,1),
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	dni VARCHAR(11) NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	id_informacion_medica INT NOT NULL,
	id_obra INT NOT NULL
	CONSTRAINT pk_paciente
		PRIMARY KEY (id_paciente),
	CONSTRAINT chk_dni
		CHECK (LEN(dni) >= 8 ),
	CONSTRAINT chk_paciente_nacimiento
		CHECK (fecha_nacimiento > '1850-00-00'),
	CONSTRAINT fk_paciente_informacion
		FOREIGN KEY (id_informacion_medica)
		REFERENCES Informacion_Medica (id_informacion_medica),
	CONSTRAINT fk_paciente_obra
		FOREIGN KEY (id_obra)
		REFERENCES Obra_Social (id_obra)
)
GO

CREATE TABLE Enfermero (
	id_enfermero INT IDENTITY(1,1), 
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	matricula NVARCHAR(100) NOT NULL,
	CONSTRAINT pk_enfermero
		PRIMARY KEY (id_enfermero)
)
GO

CREATE TABLE Habitacion (
	id_habitacion INT IDENTITY(1,1),
	numero SMALLINT NOT NULL,
	piso SMALLINT NOT NULL,
	camas TINYINT NOT NULL,
	CONSTRAINT unq_habitacion_numero_piso
		UNIQUE (numero, piso),
	CONSTRAINT chk_habitacinon_numero
		CHECK (numero >= 0),
	CONSTRAINT chk_habitacion_piso
		CHECK (piso >= 0),
	CONSTRAINT chk_habitacion_camas
		CHECK (camas >= 0),
	CONSTRAINT pk_habitacion
		PRIMARY KEY (id_habitacion)
)
GO

CREATE TABLE Enfermero_asignado (
	id_enfermero INT NOT NULL,
	id_habitacion INT NOT NULL,
	CONSTRAINT fk_enfermeroAsignado_enfermero
		FOREIGN KEY (id_enfermero)
		REFERENCES Enfermero (id_enfermero),
	CONSTRAINT fk_enfermeroAsignado_habitacion
		FOREIGN KEY (id_habitacion)
		REFERENCES Habitacion (id_habitacion),
	CONSTRAINT unq_enfermero_asignado
		UNIQUE (id_enfermero, id_habitacion)
)	
GO

CREATE TABLE Receta (
	id_receta INT IDENTITY(1,1),
	fecha_emision DATE NOT NULL,
	observaciones NVARCHAR(200),
	id_paciente INT NOT NULL,
	id_medico INT NOT NULL,
	CONSTRAINT pk_receta
		PRIMARY KEY (id_receta),
	CONSTRAINT fk_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES Paciente (id_paciente),
	CONSTRAINT fk_medico
		FOREIGN KEY (id_medico)
		REFERENCES Medico (id_medico)
)
GO

EXEC sp_rename 'fk_paciente','fk_receta_paciente','OBJECT'
GO
EXEC sp_rename 'fk_medico','fk_receta_medico','OBJECT'
GO


CREATE TABLE Medicamento (
	id_medicamento INT IDENTITY(1,1),
	nombre_comercial VARCHAR(100) NOT NULL,
	droga_activa VARCHAR(100),
	miligramos INT,
	CONSTRAINT pk_medicamento
		PRIMARY KEY (id_medicamento),
	CONSTRAINT chk_medicamento_miligramos
		CHECK (miligramos >= 0)
)
GO

CREATE TABLE Receta_Detalle (
	id_receta INT NOT NULL,
	id_medicamento INT NOT NULL,
	dosis TINYINT NOT NULL
	CONSTRAINT chk_dosis 
		CHECK (dosis >= 0)
	CONSTRAINT fk_receta
		FOREIGN KEY (id_receta)
		REFERENCES Receta (id_receta),
	CONSTRAINT fk_medicamento
		FOREIGN KEY (id_medicamento)
		REFERENCEs Medicamento (id_medicamento)
)
GO

EXEC sp_rename 'fk_receta', 'fk_recetaDetalle_receta', 'OBJECT'
GO
EXEC sp_rename 'fk_medicamento', 'fk_recetaDetalle_medicamento', 'OBJECT'
GO
EXEC sp_rename 'chk_dosis', 'chk_recetaDetalle_dosis', 'OBJECT'
GO


CREATE TABLE Turno (
	id_turno INT IDENTITY(1,1),
	fecha_hora SMALLDATETIME NOT NULL,
	estado_finalizada BIT,
	motivo VARCHAR(200),
	id_paciente INT NOT NULL,
	id_medico INT NOT NULL,
	CONSTRAINT pk_turno
		PRIMARY KEY (id_turno),
	CONSTRAINT fk_turno_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES Paciente (id_paciente),
	CONSTRAINT fk_turno_medico
		FOREIGN KEY (id_medico)
		REFERENCES Medico (id_medico)
)
GO

ALTER TABLE Turno
ADD CONSTRAINT chk_turno_fecha 
CHECK (fecha_hora >= '2026-09-01')
GO


CREATE TABLE Registro_Clinico (
	id_registroClinico INT IDENTITY,
	fecha_hora SMALLDATETIME NOT NULL,
	diagnostico VARCHAR(200),
	tratamiento VARCHAR(200),
	observaciones VARCHAR(200),
	id_paciente INT NOT NULL,
	id_medico INT NOT NULL,
	CONSTRAINT pk_registroClinico
		PRIMARY KEY (id_registroClinico),
	CONSTRAINT fk_registroClinico_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES Paciente (id_paciente),
	CONSTRAINT fk_registroClinico_medico
		FOREIGN KEY (id_medico)
		REFERENCES Medico (id_medico),
	CONSTRAINT chk_registroClinico_fechaHora
		CHECK (fecha_hora >= '2026-09-01')
)
GO

CREATE TABLE Cirujia (
	id_cirujia INT IDENTITY(1,1),
	motivo VARCHAR(200),
	fecha_hora SMALLDATETIME NOT NULL,
	id_habitacion INT NOT NULL, 
	id_medico INT NOT NULL,
	id_paciente INT NOT NULL,
	CONSTRAINT pk_cirujia
		PRIMARY KEY (id_cirujia),
	CONSTRAINT fk_cirujia_habitacion
		FOREIGN KEY (id_habitacion)
		REFERENCES Habitacion (id_habitacion),
	CONSTRAINT fk_cirujia_paciente
		FOREIGN KEY (id_medico)
		REFERENCEs Medico (id_medico),
	CONSTRAINT fk_cirujia_medico
		FOREIGN KEY (id_paciente)
		REFERENCES Paciente (id_paciente)
)
GO

CREATE TABLE Internacion (
	id_internacion INT IDENTITY(1,1),
	fecha_hora_ingreso SMALLDATETIME NOT NULL, 
	fecha_hora_egreso SMALLDATETIME,
	diagnostico_ingreso VARCHAR(300),
	id_paciente INT NOT NULL,
	id_habitacion INT NOT NULL,
	CONSTRAINT pk_internacion
		PRIMARY KEY (id_internacion),
	CONSTRAINT fk_internacion_paciente
		FOREIGN KEY (id_paciente)
		REFERENCES Paciente (id_paciente),
	CONSTRAINT fk_interanacion_habitacion
		FOREIGN KEY (id_habitacion)
		REFERENCES Habitacion (id_habitacion)
)
GO