CREATE FUNCTION removeLinhaColuna(i int, j int, mat float[][]) RETURNS float[][] AS $$
DECLARE
    resp float[][];
    currentLin int;
    currentCol int;
BEGIN
    matlin := array_ndims(mat);
    matcol :=  array_ndims(mat[0]);

    currentLin := 0;
    FOR linha IN 0..matlin LOOP
        IF linha <> i THEN
            resp := array_append(resp, ARRAY[]);
            currentLin += 1;
        END IF;
        currentCol := 0;
        FOR coluna IN 0..matcol LOOP
            IF linha <> i AND coluna <> j THEN
                resp[currentLin][currentCol] := array_append(resp[currentLin][currentCol], mat[linha][coluna]);
                currentCol += 1;
            END IF;
        END LOOP;
    END LOOP;
    RETURN resp;
END;
$$ LANGUAGE plpgsql;

