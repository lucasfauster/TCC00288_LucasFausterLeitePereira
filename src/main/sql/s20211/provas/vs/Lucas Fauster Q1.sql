
CREATE OR REPLACE FUNCTION cofatora(matriz float[][], i int, j int) RETURNS float[][] AS $cofatora$
DECLARE
 w float[][];
 z float[];
BEGIN
    FOR i2 in 1..array_length(matriz, 1) LOOP
        FOR j2 in 1..array_length(matriz, 2) LOOP
            IF i2 <> i AND j2 <> j THEN
                z := array_append(z, matriz[i2][j2]);
            END IF;
        END LOOP;
    END LOOP;
    RETURN w;
END;
$cofatora$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION determinante(matriz float[][]) RETURNS float AS $det$
    DECLARE
        det FLOAT := 0;
    BEGIN
        IF array_length(matriz,1) <> array_length(matriz,2) THEN
            RAISE EXCEPTION 'Número de linhas e colunas diferentes';
        END IF;

        IF array_length(matriz,1) = 1 THEN
            return matriz[1][1];
        END IF;

        IF array_length(matriz, 1) = 2  THEN
            return matriz[1][1]*matriz[2][2] - matriz[1][2]*matriz[2][1];
        END IF;

        IF array_length(matriz,2) IS NOT NULL THEN
            FOR col IN 1..array_length(matriz,2) LOOP
                det = det + matriz[1][col]*POW(-1,1+col)*determinante(cofatora(matriz,1,col));
            END LOOP;
        END IF;

        RETURN det;
    END;
$det$ LANGUAGE plpgsql;
