
DROP function actualizarModelo() CASCADE;
DROP language plpgsql;

CREATE LANGUAGE plpgsql;

CREATE FUNCTION actualizarModelo() RETURNS TRIGGER AS $$
    DECLARE
        id_meta integer;
        id_metafact integer;
	contador integer;
	nombre_hc varchar;
	unidad_t varchar;
	tiempo date;
	estacion_id varchar;
	id_metadesc integer;
	fecha_i date;
	fecha_f date;
    
     BEGIN
	contador := 0;
	-- id_meta := 0;
        SELECT into id_metafact max(id)
	FROM medidavarhc_facts;

	if id_metafact is null THEN
		id_metafact := 1;
	END IF;
	
        -- Selecciono los datos de las dimensiones que referencia nuestra medida
		SELECT into nombre_hc v.nombre_hc --, unidad_t, tiempo, e.id
		FROM tiempo_dimension t, 
		     estacion_dimension e, 
		     variable_hidroclimatica v
		WHERE NEW.tiempo_id = t.id AND 
		      NEW.estacion_id = e.id AND 
		      NEW.nombre_hc = v.nombre_hc;
		SELECT into unidad_t t.unidad_t -- , tiempo, e.id
		FROM tiempo_dimension t, 
		     estacion_dimension e, 
		     variable_hidroclimatica v
		WHERE NEW.tiempo_id = t.id AND 
		      NEW.estacion_id  = e.id AND 
		      NEW.nombre_hc = v.nombre_hc;
		SELECT into tiempo t.tiempo -- e.id
		FROM tiempo_dimension t, 
		     estacion_dimension e, 
		     variable_hidroclimatica v
		WHERE NEW.tiempo_id = t.id AND 
		      NEW.estacion_id  = e.id AND 
		      NEW.nombre_hc = v.nombre_hc;
		SELECT into estacion_id e.id
		FROM tiempo_dimension t, 
		     estacion_dimension e, 
		     variable_hidroclimatica v
		WHERE NEW.tiempo_id = t.id AND 
		      NEW.estacion_id  = e.id AND 
		      NEW.nombre_hc = v.nombre_hc;

	IF nombre_hc IS NULL OR unidad_t IS NULL OR tiempo IS NULL OR estacion_id IS NULL THEN
		RAISE EXCEPTION 'Error fatal, algo pasa...';
		RETURN null;
	END IF;
        
        -- Selecciono el descriptor de datos que coinciden con mi medida
		SELECT into id_metadesc m.id_metadesc -- m.fecha_inicio, m.fecha_fin
		FROM metadatos_desc m
		WHERE m.tipo_variable = 'Ambiental' AND
		      m.codigo_estacion_muni = estacion_id AND
		      m.variable = nombre_hc AND
		      m.granularidad = unidad_t;
		SELECT into fecha_i m.fecha_inicio --, m.fecha_fin
		FROM metadatos_desc m
		WHERE m.tipo_variable = 'Ambiental' AND
		      m.codigo_estacion_muni = estacion_id AND
		      m.variable = nombre_hc AND
		      m.granularidad = unidad_t;
		SELECT into fecha_f m.fecha_fin
		FROM metadatos_desc m
		WHERE m.tipo_variable = 'Ambiental' AND
		      m.codigo_estacion_muni = estacion_id AND
		      m.variable = nombre_hc AND
		      m.granularidad = unidad_t;


	IF id_metadesc IS NULL THEN
            INSERT INTO metadatos_desc (tipo_variable,codigo_estacion_muni,variable,granularidad,fecha_inicio,fecha_fin)
            VALUES ('Ambiental', estacion_id, nombre_hc, unidad_t, tiempo, tiempo);
            --  TODO -> Ver y adaptar a lo que dice Gian :)
            -- id_meta := currval('metadatos_desc_id_metadesc_seq') - 1;
                       SELECT into id_meta m.id_metadesc
                       FROM metadatos_desc m
                       WHERE m.tipo_variable = 'Ambiental' AND
                             m.codigo_estacion_muni = estacion_id AND
                             m.variable = nombre_hc AND
                             m.granularidad = unidad_t AND
			     m.fecha_inicio = tiempo AND
			     m.fecha_fin = tiempo;
        ELSE

	    IF (fecha_i <= tiempo AND tiempo <= fecha_f) THEN
		id_meta := id_metadesc;
	    END IF;

            IF fecha_i > tiempo THEN
                IF (fecha_i - tiempo) < 365 THEN
	                UPDATE metadatos_desc m
	                SET fecha_inicio = tiempo
	                WHERE m.id_metadesc = id_metadesc;
	                id_meta := id_metadesc;
	            ELSE
	                INSERT INTO metadatos_desc (tipo_variable,codigo_estacion_muni,variable,granularidad,fecha_inicio,fecha_fin)
			VALUES ('Ambiental', estacion_id, nombre_hc, unidad_t, tiempo, tiempo);
			-- id_meta := currval('metadatos_desc_id_metadesc_seq') - 1;
			SELECT into id_meta id_metadesc
                        FROM metadatos_desc m
                        WHERE m.tipo_variable = 'Ambiental' AND
                              m.codigo_estacion_muni = estacion_id AND
                              m.variable = nombre_hc AND
                              m.granularidad = unidad_t AND
			      m.fecha_inicio = tiempo AND
			      m.fecha_fin = tiempo;
		END IF;
            END IF;
            
            IF fecha_f < tiempo THEN
                IF (tiempo - fecha_f) < 365 THEN
	                UPDATE metadatos_desc m
	                SET fecha_fin = tiempo
	                WHERE m.id_metadesc = id_metadesc;
	                id_meta := id_metadesc;
	            ELSE
	                INSERT INTO metadatos_desc (tipo_variable,codigo_estacion_muni,variable,granularidad,fecha_inicio,fecha_fin)
			VALUES ('Ambiental', estacion_id, nombre_hc, unidad_t, tiempo, tiempo);
			SELECT into id_meta id_metadesc
                        FROM metadatos_desc m
                        WHERE m.tipo_variable = 'Ambiental' AND
                              m.codigo_estacion_muni = estacion_id AND
                              m.variable = nombre_hc AND
                              m.granularidad = unidad_t AND
			      m.fecha_inicio = tiempo AND
			      m.fecha_fin = tiempo;
		END IF;
	    END IF;

	   
	END IF;
              

	IF id_meta IS NULL THEN
		RAISE EXCEPTION 'AJA';
		RETURN NULL;
	END IF;
        -- Agregar el row_id con el id_meta a la tabla "bajo nivel"
        INSERT into metadatos_rowids VALUES (id_meta, id_metafact);
        RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

CREATE TRIGGER actualizarModelo AFTER INSERT ON medidavarhc_facts
        
FOR EACH ROW EXECUTE PROCEDURE actualizarModelo();
