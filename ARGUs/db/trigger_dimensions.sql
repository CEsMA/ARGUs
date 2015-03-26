DROP function estacion_dim() CASCADE;
DROP function unidad_dim() CASCADE;
DROP FUNCTION variable_dim() CASCADE;
DROP function actualizar_estacion() CASCADE;
DROP language plpgsql;
CREATE LANGUAGE plpgsql;

CREATE FUNCTION estacion_dim() RETURNS TRIGGER AS $$

    BEGIN
        INSERT INTO estacion_dimension (altura_est,nombre_est,latitud_est,longitud_est) values (NEW.altura,NEW.nombre,NEW.latitud,NEW.longitud);
	    RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER estacion_dim BEFORE INSERT ON estaciones
        
FOR EACH ROW EXECUTE PROCEDURE estacion_dim();


CREATE FUNCTION unidad_dim() RETURNS TRIGGER AS $$

    BEGIN
        INSERT INTO unidad_dimension (unidad_medida_u) values (NEW.nombre_unid);
	    RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER unidad_dim BEFORE INSERT ON unidads
        
FOR EACH ROW EXECUTE PROCEDURE unidad_dim();

CREATE FUNCTION variable_dim() RETURNS TRIGGER AS $$

    BEGIN
        INSERT INTO variable_dimension (nombre_hc) values (NEW.nombre_hc);
	    RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER variable_dim BEFORE INSERT ON variable_hidroclimaticas
        
FOR EACH ROW EXECUTE PROCEDURE variable_dim();



CREATE FUNCTION actualizar_estacion() RETURNS TRIGGER AS $$

    DECLARE
    nombre_est varchar;
    
    BEGIN
	NEW.actual := 'SI';
	
        SELECT into nombre_est e.nombre
        FROM estaciones e
        WHERE nombre = NEW.nombre;
    
        IF nombre_est IS NULL THEN
        
        ELSE
            UPDATE estaciones SET actual = 'NO' WHERE nombre = nombre_est;
	    END IF;
	    RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_estacion BEFORE INSERT ON estaciones
        
FOR EACH ROW EXECUTE PROCEDURE actualizar_estacion();
