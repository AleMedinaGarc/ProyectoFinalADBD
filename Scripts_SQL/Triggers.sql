---------------------------
-- CREACION DE TRIGGERS
-- Alejandro Medina Garcia
-- Eduardo Da Silva Yanes
---------------------------
-------------------------------------
-- PARTE 1: CREACION DE LAS FUNCIONES
-------------------------------------
-- TRIGGER FUNCTION 1
DROP TRIGGER IF EXISTS check_mantenimiento_before_insert_reserva ON RESERVAS;
DROP FUNCTION IF EXISTS check_mantenimiento();

CREATE OR REPLACE FUNCTION check_mantenimiento() RETURNS TRIGGER AS $example$
BEGIN
  IF NEW.Fecha = ANY 
    (SELECT DISTINCT  Fecha
		 FROM MANTENIMIENTO
     WHERE NEW.Fecha = Fecha AND NEW.idBarco = idBarco)
  THEN
    RAISE NOTICE 'Barco en mantenimiento';
      RETURN NULL;
  END IF;
  RETURN NEW;
END;
$example$ LANGUAGE plpgsql;

-- TRIGGER FUNCTION 2
DROP TRIGGER IF EXISTS check_title_before_insert_reserva ON RESERVAS;
DROP FUNCTION IF EXISTS check_title();

CREATE OR REPLACE FUNCTION check_title() RETURNS TRIGGER AS $example2$
DECLARE 
  Eslora_R INTEGER;
  Titulo_R VARCHAR;
  Patron_R VARCHAR;	
BEGIN
	-- Buscar la eslora del barco perteneciente a la reserva
	SELECT Eslora INTO Eslora_R
	FROM BARCOS
	WHERE NEW.idBarco = matriculaBarco;
    
    -- Buscar el titulo del cliente 
IF NEW.DNI_patron = ANY
  (SELECT DNI_patron FROM PATRON_CONTRATADO)
THEN
  SELECT Titulo_patron INTO Titulo_R
	FROM PATRON_CONTRATADO
	WHERE NEW.DNI_patron = DNI_patron;
ELSE
  SELECT Titulo INTO Titulo_R
	FROM USUARIOS_CLIENTES
	WHERE NEW.DNI_cliente = DNI_cliente;
END IF;	


    
    -- Switch case de la eslora obvtenida segun el titulo
	CASE Eslora_R::INTEGER
		WHEN 6::INTEGER THEN 
			IF (Titulo_R::VARCHAR != 'LN' AND  Titulo_R::VARCHAR != 'PNB' AND Titulo_R::VARCHAR != 'PER' AND Titulo_R::VARCHAR != 'PY' AND Titulo_R::VARCHAR != 'CY') THEN 
				RAISE NOTICE 'No puede navegar con un barco de eslora 6m';				
				RETURN NULL;
			END IF;
		WHEN 8::INTEGER THEN
			IF (Titulo_R::VARCHAR != 'PNB' AND Titulo_R::VARCHAR != 'PER' AND Titulo_R::VARCHAR != 'PY' AND Titulo_R::VARCHAR != 'CY') THEN 
				RAISE NOTICE 'No puede navegar con un barco de eslora 8m';				
				RETURN NULL;
			END IF;
		WHEN 15::INTEGER THEN
			IF (Titulo_R::VARCHAR != 'PER' AND Titulo_R::VARCHAR != 'PY' AND Titulo_R::VARCHAR != 'CY') THEN 
				RAISE NOTICE 'No puede navegar con un barco de eslora 15m';				
				RETURN NULL;
			END IF;
		WHEN 24::INTEGER THEN
			IF (Titulo_R::VARCHAR != 'PY' AND Titulo_R::VARCHAR != 'CY') THEN 
				RAISE NOTICE 'No puede navegar con un barco de eslora 24m';				
				RETURN NULL;
			END IF;
	END CASE;
  RETURN NEW;
END;
$example2$ LANGUAGE plpgsql;

-- TRIGGER FUNCTION 3
DROP TRIGGER IF EXISTS check_verificado_before_insert_reserva ON RESERVAS;
DROP FUNCTION IF EXISTS check_verificado();

CREATE OR REPLACE FUNCTION check_verificado() RETURNS TRIGGER AS $example3$
DECLARE 
  User_R varchar;
BEGIN
	SELECT * INTO User_R
    FROM VERIFICADOS 
    WHERE DNI_CLIENTE = NEW.DNI_cliente;
    
	IF User_R IS NULL
    THEN 
	raise notice 'Los datos de ese cliente no estan verificados';
	RETURN NULL;
  END IF;
 RETURN NEW;
END;
$example3$ LANGUAGE plpgsql;

-- TRIGGER FUNCTION 4
DROP TRIGGER IF EXISTS check_barco_ocupado_before_insert_reserva ON RESERVAS;
DROP FUNCTION IF EXISTS check_barco_ocupado();

CREATE OR REPLACE FUNCTION check_barco_ocupado() RETURNS TRIGGER AS $example4$
DECLARE 
  Boat_R varchar;
BEGIN
	SELECT * INTO Boat_R
    FROM RESERVAS 
    WHERE Fecha = NEW.Fecha AND Turno = NEW.Turno;
    
	IF Boat_R IS NOT NULL
	THEN 
	raise notice 'Ese barco ya tiene una reserva para ese fecha y turno';	
	RETURN NULL;
  END IF;

  RETURN NEW;
END;
$example4$ LANGUAGE plpgsql;

---------------------
-- PARTE 2: CREACION DE LOS TRIGGERS
---------------------
CREATE TRIGGER check_mantenimiento_before_insert_reserva BEFORE INSERT ON RESERVAS
FOR EACH ROW EXECUTE PROCEDURE check_mantenimiento();

CREATE TRIGGER check_title_before_insert_reserva BEFORE INSERT ON RESERVAS
FOR EACH ROW EXECUTE PROCEDURE check_title();

CREATE TRIGGER check_verificado_before_insert_reserva BEFORE INSERT ON RESERVAS
FOR EACH ROW EXECUTE PROCEDURE check_verificado();

CREATE TRIGGER check_barco_ocupado_before_insert_reserva BEFORE INSERT ON RESERVAS
FOR EACH ROW EXECUTE PROCEDURE check_barco_ocupado();
