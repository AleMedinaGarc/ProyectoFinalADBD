-- -----------------------------------------------------
-- Data for table BARCOS
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE BARCOS'
START TRANSACTION;

INSERT INTO BARCOS (MatriculaBarco, Nombre, Puerto, Pantalan, Numero, Eslora) VALUES (2736, 'Pinta', 'Los Cristianos', '7', '3', 6);
INSERT INTO BARCOS (MatriculaBarco, Nombre, Puerto, Pantalan, Numero, Eslora) VALUES (2733, 'Niña', 'Los Cristianos', '7', '4', 8);
INSERT INTO BARCOS (MatriculaBarco, Nombre, Puerto, Pantalan, Numero, Eslora) VALUES (2737, 'Santa María', 'Las Galletas', '4', '6', 8);

COMMIT;


-- -----------------------------------------------------
-- Data for table EMPRESA
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE EMPRESA'
START TRANSACTION;

INSERT INTO EMPRESA (NIFEmpresa, nombreEmpresa, Telefono, Dirección) VALUES ('12343454', 'Empresa1', 677274658, 'Calle Test 1, nº4');
INSERT INTO EMPRESA (NIFEmpresa, nombreEmpresa, Telefono, Dirección) VALUES ('54545345', 'Empresa2', 666653425, 'Calle Test 2, nº4');
INSERT INTO EMPRESA (NIFEmpresa, nombreEmpresa, Telefono, Dirección) VALUES ('45454534', 'Empresa3', 253857456, 'Calle Test 3, nº4');

COMMIT;

-- -----------------------------------------------------
-- Data for table PATRON_CONTRATADO
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE PATRON CONTRATADO'
START TRANSACTION;

INSERT INTO PATRON_CONTRATADO (DNI_patron, Nombre, Apellidos, IBAN, Numero_Seguridad_Social, Direccion, Titulo_patron) VALUES ('55555555F', 'Miguel', 'Sanchez', '637465736574456BDGF', '637FDGFFGF4456BDGF', 'Calle Patrón 1', 'CY');

COMMIT;


-- -----------------------------------------------------
-- Data for table HORARIO
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE HORARIO'
START TRANSACTION;

INSERT INTO HORARIO (idHorario, DNI_patron, dia_semana, Turno) VALUES (1, '55555555F', 'Lunes', 'todo');
INSERT INTO HORARIO (idHorario, DNI_patron, dia_semana, Turno) VALUES (2, '55555555F', 'Miercoles', 'tarde');
INSERT INTO HORARIO (idHorario, DNI_patron, dia_semana, Turno) VALUES (3, '55555555F', 'Viernes', 'mañana');

COMMIT;


-- -----------------------------------------------------
-- Data for table MANTENIMIENTO
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE MANTENIMIENTO'
START TRANSACTION;

INSERT INTO MANTENIMIENTO (idMantenimiento, idBarco, NIFEmpresa, Fecha, Turno, Precio) VALUES (1, 2736, '12343454', '2022-07-18', 'tarde', 100);
INSERT INTO MANTENIMIENTO (idMantenimiento, idBarco, NIFEmpresa, Fecha, Turno, Precio) VALUES (2, 2736, '12343454', '2022-09-18', 'tarde', 200);
INSERT INTO MANTENIMIENTO (idMantenimiento, idBarco, NIFEmpresa, Fecha, Turno, Precio) VALUES (3, 2736, '54545345', '2022-10-18', 'tarde', 500);

COMMIT;

-- -----------------------------------------------------
-- Data for table USUARIOS_CLIENTES
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE CLIENTES'
START TRANSACTION;

INSERT INTO USUARIOS_CLIENTES (DNI_cliente, Correo, Nombre, Apellidos, Password, Direccion, Titulo, Telefono) VALUES ('11111111A', 'correo1@gmail.com', 'Juan', 'Acosta', '8237467364', 'Calle Dirección Usuario 1', 'LN', 657463785);
INSERT INTO USUARIOS_CLIENTES (DNI_cliente, Correo, Nombre, Apellidos, Password, Direccion, Titulo, Telefono) VALUES ('22222222B', 'correo2@gmail.com', 'Pedro', 'Pérez', '3254465346', 'Calle Dirección Usuario 1', 'NO', 345274859);
INSERT INTO USUARIOS_CLIENTES (DNI_cliente, Correo, Nombre, Apellidos, Password, Direccion, Titulo, Telefono) VALUES ('33333333C', 'correo3@gmail.com', 'Ana', 'García', '4564565464', 'Calle Dirección Usuario 1', 'PNB', 467284546);

COMMIT;

-- -----------------------------------------------------
-- Data for table USUARIOS_ADMIN
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE ADMINISTRADORES'
START TRANSACTION;
INSERT INTO USUARIOS_ADMIN (DNI_admin, Correo, Nombre, Apellidos, Password) VALUES ('44444444D', 'admin1@gmail.com', 'Alba', 'Bermejo', '346736574354');
INSERT INTO USUARIOS_ADMIN (DNI_admin, Correo, Nombre, Apellidos, Password) VALUES ('55555555E', 'admin2@gmail.com', 'María', 'Plumed', '454957485846');

COMMIT;

-- -----------------------------------------------------
-- Data for table VERIFICADOS
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE VERIFICADOS'
START TRANSACTION;

INSERT INTO VERIFICADOS (DNI_cliente, DNI_admin, Fecha) VALUES ('11111111A', '44444444D', '2022-07-23');
INSERT INTO VERIFICADOS (DNI_cliente, DNI_admin, Fecha) VALUES ('22222222B', '44444444D', '2022-07-24');

COMMIT;

-- -----------------------------------------------------
-- Data for table RESERVAS
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE RESERVAS'
START TRANSACTION;

INSERT INTO RESERVAS (idReserva, idBarco, DNI_patron, DNI_patron_cliente, DNI_cliente, Fecha, Turno, Comentario) VALUES (1, 2736, '55555555F', NULL , '11111111A', '2022-10-13', 'tarde', NULL);
INSERT INTO RESERVAS (idReserva, idBarco, DNI_patron, DNI_patron_cliente, DNI_cliente, Fecha, Turno, Comentario) VALUES (2, 2736, '55555555F', NULL , '22222222B', '2022-1-12', 'tarde', NULL);


COMMIT;

-- -----------------------------------------------------
-- Data for table PAGO
-- -----------------------------------------------------
\echo '## INSERTAR DATOS DE PAGOS'
START TRANSACTION;

INSERT INTO PAGO (idPago, idReserva, tipo_comprobante, num_comprobante, total_pago, fecha_emision, fecha_pago) VALUES (1, 1, 'X', 2335, 100, '2022-01-22', '2022-01-22');
INSERT INTO PAGO (idPago, idReserva, tipo_comprobante, num_comprobante, total_pago, fecha_emision, fecha_pago) VALUES (2, 2, 'Y', 4546, 100, '2022-01-22', '2022-01-22');
COMMIT;

\echo '#### Intentar insertar un pago para una reserva inexistente'
START TRANSACTION;
INSERT INTO PAGO (idPago, idReserva, tipo_comprobante, num_comprobante, total_pago, fecha_emision, fecha_pago) VALUES (3, 3, 'Z', 6565, 150, '2022-01-22', '2022-01-22');
COMMIT;
-- -------------------------------
-- Datos que activan los triggers
-- -------------------------------
\echo '## INSERTAR DATOS QUE ACTIVAN LOS TRIGGERS'
-- El barco 2737 tiene 8m de eslora. El cliente 11111111A quiere navegar pero su licencia LN no se lo permite.
   INSERT INTO RESERVAS (idReserva, idBarco, DNI_patron, DNI_patron_cliente, DNI_cliente, Fecha, Turno, Comentario) VALUES (4, 2737, NULL ,'11111111A', '11111111A', '2022-12-13', 'mañana', NULL);
-- Intento reservar un barco que esta en mantenimiento
   INSERT INTO RESERVAS (idReserva, idBarco, DNI_patron, DNI_patron_cliente, DNI_cliente, Fecha, Turno, Comentario) VALUES (5, 2736, '55555555F' , NULL , '11111111A', '2022-07-18', 'tarde', NULL);
-- Intento de reserva con un cliente que aun no ha sido verificado
   INSERT INTO RESERVAS (idReserva, idBarco, DNI_patron, DNI_patron_cliente, DNI_cliente, Fecha, Turno, Comentario) VALUES (6, 2737, '55555555F' , NULL , '33333333C', '2022-12-12', 'mañana', NULL);
   INSERT INTO RESERVAS (idReserva, idBarco, DNI_patron, DNI_patron_cliente, DNI_cliente, Fecha, Turno, Comentario) VALUES (3, 2736, NULL , '33333333C' , '33333333C', '2022-12-12', 'mañana', NULL);
-- Intento reservar un barco que ya esta ocupado
   INSERT INTO RESERVAS (idReserva, idBarco, DNI_patron, DNI_patron_cliente, DNI_cliente, Fecha, Turno, Comentario) VALUES (1, 2736, '55555555F', NULL , '22222222B', '2022-10-13', 'tarde', NULL);



