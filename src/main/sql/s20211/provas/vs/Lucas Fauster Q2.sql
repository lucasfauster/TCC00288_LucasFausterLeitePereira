CREATE OR REPLACE FUNCTION data_valida(inicio_reserva timestamp, fim_reserva timestamp, inicio_estadia timestamp, fim_estadia timestamp) RETURNS BOOLEAN AS $data_valida$
    BEGIN
        RETURN ((date_trunc('day', inicio_reserva) = date_trunc('day', inicio_estadia)) OR (date_trunc('day', inicio_reserva) + $$1 day$$::INTERVAL >= date_trunc('day', inicio_estadia))) AND (fim_estadia IS NULL OR (date_trunc('day', fim_reserva) >= date_trunc('day', fim_estadia)));
    END;
$data_valida$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION estadia_valida() RETURNS TRIGGER AS $estadia$
    DECLARE
    reserva_record RECORD;
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
            SELECT numero, inicio, fim INTO STRICT reserva_record 
            FROM reserva 
            WHERE numero = OLD.numero;
            
            IF(data_valida(reserva_record.inicio, reserva_record.fim, NEW.inicio, NEW.fim)) THEN
                RETURN NEW;
            END IF;

            RAISE EXCEPTION 'Intervalo invalido';

            RETURN NULL;

        ELSIF (TG_OP = 'INSERT') THEN
            SELECT numero, inicio, fim INTO STRICT reserva_record 
            FROM reserva 
            WHERE numero = NEW.numero;

            IF(data_valida(reserva_record.inicio, reserva_record.fim, NEW.inicio, NEW.fim)) THEN
                RETURN NEW;
            END IF;
            
            RAISE EXCEPTION 'Intervalo invalido';
            RETURN NULL;
        END IF;
        RETURN NULL;
    END;
$estadia$ LANGUAGE plpgsql;

CREATE TRIGGER tgr_estadia
    BEFORE INSERT OR UPDATE ON estadia
    FOR EACH ROW
    EXECUTE PROCEDURE estadia_valida();
