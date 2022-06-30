-- Script de creacion de las tablas de la base de datos
-- Alejandro Medina Garcia
-- Eduardo Da Silva Yanes

-- Eliminar tablas
\echo '## ELIMINA LAS TABLAS EN CASO DE EXISTIR'
DROP TABLE IF EXISTS BARCOS CASCADE;
DROP TABLE IF EXISTS EMPRESA CASCADE;
DROP TABLE IF EXISTS PATRON_CONTRATADO CASCADE;
DROP TABLE IF EXISTS HORARIO CASCADE;
DROP TABLE IF EXISTS MANTENIMIENTO CASCADE;
DROP TABLE IF EXISTS USUARIOS_CLIENTES CASCADE;
DROP TABLE IF EXISTS USUARIOS_ADMIN CASCADE;
DROP TABLE IF EXISTS VERIFICADOS CASCADE;
DROP TABLE IF EXISTS RESERVAS CASCADE;
DROP TABLE IF EXISTS PAGO CASCADE;

CREATE TYPE valid_turnos AS ENUM('tarde', 'mañana', 'todo');

-- -----------------------------------------------------
-- Table BARCOS
-- -----------------------------------------------------
\echo '## TABLA BARCOS'
CREATE TABLE IF NOT EXISTS BARCOS (
  MatriculaBarco INT NOT NULL,
  Nombre VARCHAR(45) NOT NULL,
  Puerto VARCHAR(45) NOT NULL,
  Pantalan VARCHAR(45) NOT NULL,
  Numero VARCHAR(45) NOT NULL,
  Eslora INT NOT NULL,
  PRIMARY KEY (MatriculaBarco));


-- -----------------------------------------------------
-- Table EMPRESA
-- -----------------------------------------------------
\echo '## TABLA EMPRESA'
CREATE TABLE IF NOT EXISTS EMPRESA (
  NIFEmpresa VARCHAR(45) NOT NULL,
  nombreEmpresa VARCHAR(45) NOT NULL,
  Telefono INT NOT NULL,
  Dirección VARCHAR(128) NULL,
  PRIMARY KEY (NIFEmpresa));

-- -----------------------------------------------------
-- Table PATRON_CONTRATADO
-- -----------------------------------------------------
\echo '## TABLA PATRON CONTRATADO'
CREATE TABLE IF NOT EXISTS PATRON_CONTRATADO (
  DNI_patron VARCHAR(9) NOT NULL,
  Nombre VARCHAR(45) NOT NULL,
  Apellidos VARCHAR(70) NULL,
  IBAN VARCHAR(45) NOT NULL,
  Numero_Seguridad_Social VARCHAR(45) NOT NULL,
  Direccion VARCHAR(45) NOT NULL,
  Titulo_patron VARCHAR(3) NOT NULL,
  PRIMARY KEY (DNI_patron));

-- -----------------------------------------------------
-- Table HORARIO
-- -----------------------------------------------------
\echo '## TABLA HORARIO'
CREATE TABLE IF NOT EXISTS HORARIO (
  idHorario SERIAL,
  DNI_patron VARCHAR(9) NOT NULL,
  dia_semana VARCHAR(45) NOT NULL,
  Turno VALID_TURNOS NOT NULL,
  PRIMARY KEY (idHorario),
  CONSTRAINT DNI_patron
    FOREIGN KEY (DNI_patron)
    REFERENCES PATRON_CONTRATADO (DNI_patron)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table MANTENIMIENTO
-- -----------------------------------------------------
\echo '## TABLA MANTENIMIENTO'
CREATE TABLE IF NOT EXISTS MANTENIMIENTO (
  idMantenimiento SERIAL,
  idBarco INT NOT NULL,
  NIFEmpresa VARCHAR(45) NOT NULL,
  Fecha DATE NOT NULL,
  Turno VALID_TURNOS NOT NULL,
  Precio DECIMAL(6) NOT NULL,
  PRIMARY KEY (idMantenimiento),
  CONSTRAINT idBarco
    FOREIGN KEY (idBarco)
    REFERENCES BARCOS (MatriculaBarco)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT NIFEmpresa
    FOREIGN KEY (NIFEmpresa)
    REFERENCES EMPRESA (NIFEmpresa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table USUARIOS_CLIENTES
-- -----------------------------------------------------
\echo '## TABLA USUARIOS CLIENTES'
CREATE TABLE IF NOT EXISTS USUARIOS_CLIENTES (
  DNI_cliente VARCHAR(9) NOT NULL UNIQUE,
  Correo VARCHAR(45) NOT NULL,
  Nombre VARCHAR(35) NOT NULL,
  Apellidos VARCHAR(65) NULL,
  Password VARCHAR(45) NOT NULL,
  Direccion VARCHAR(100) NOT NULL,
  Titulo VARCHAR(3) NOT NULL,
  Telefono INT NOT NULL,
  PRIMARY KEY (DNI_cliente, Correo));

-- -----------------------------------------------------
-- Table USUARIOS_ADMIN
-- -----------------------------------------------------
\echo '## TABLAS USUARIOS ADMIN'
CREATE TABLE IF NOT EXISTS USUARIOS_ADMIN (
  DNI_admin VARCHAR(9) NOT NULL UNIQUE,
  Correo VARCHAR(45) NOT NULL,
  Nombre VARCHAR(35) NOT NULL,
  Apellidos VARCHAR(65) NULL,
  Password VARCHAR(45) NOT NULL,
  PRIMARY KEY (DNI_admin, Correo));


-- -----------------------------------------------------
-- Table VERIFICADOS
-- -----------------------------------------------------
\echo '## TABLAS USUARIOS VERIFICADOS'
CREATE TABLE IF NOT EXISTS VERIFICADOS (
  DNI_cliente VARCHAR(9) NOT NULL,
  DNI_admin VARCHAR(9) NOT NULL,
  Fecha DATE NOT NULL,
  PRIMARY KEY (DNI_cliente),
  CONSTRAINT DNI_cliente
    FOREIGN KEY (DNI_cliente)
    REFERENCES USUARIOS_CLIENTES (DNI_cliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT DNI_admin
    FOREIGN KEY (DNI_admin)
    REFERENCES USUARIOS_ADMIN (DNI_admin)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table RESERVAS
-- -----------------------------------------------------
\echo '## TABLA RESERVAS'
CREATE TABLE IF NOT EXISTS RESERVAS (
  idReserva SERIAL,
  idBarco INT NOT NULL,
  DNI_patron VARCHAR(9),
  DNI_patron_cliente VARCHAR(9),
  DNI_cliente VARCHAR(9) NOT NULL,
  Fecha DATE NOT NULL,
  Turno VALID_TURNOS NOT NULL,
  Comentario VARCHAR(1000) NULL,
  PRIMARY KEY (idReserva),
  CONSTRAINT fk_DNI_cliente
    FOREIGN KEY (DNI_cliente)
    REFERENCES USUARIOS_CLIENTES (DNI_cliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_ID_barco
    FOREIGN KEY (idBarco)
    REFERENCES BARCOS (MatriculaBarco)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_DNI_patron_contratado
    FOREIGN KEY (DNI_patron)
    REFERENCES PATRON_CONTRATADO (DNI_patron)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_DNI_patron_cliente
    FOREIGN KEY (DNI_patron_cliente)
    REFERENCES USUARIOS_CLIENTES (DNI_cliente)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT chk_only_one_patron CHECK (
    (DNI_patron IS NOT NULL AND DNI_patron_cliente IS NULL) OR
    (DNI_patron IS NULL AND DNI_patron_cliente IS NOT NULL)));

-- -----------------------------------------------------
-- Table PAGO
-- -----------------------------------------------------
\echo '## TABLA PAGO'
CREATE TABLE IF NOT EXISTS PAGO (
  idPago SERIAL,
  idReserva INT NOT NULL,
  tipo_comprobante VARCHAR(45) NOT NULL,
  num_comprobante INT NOT NULL,
  total_pago DECIMAL(6) NOT NULL,
  fecha_emision DATE NOT NULL,

  fecha_pago DATE NOT NULL,
  PRIMARY KEY (idPago),
  CONSTRAINT idReserva
    FOREIGN KEY (idReserva)
    REFERENCES RESERVAS (idReserva)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

