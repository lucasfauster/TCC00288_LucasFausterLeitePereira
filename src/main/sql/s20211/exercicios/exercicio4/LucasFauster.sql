CREATE FUNCTION removeLinhaColuna(i int, j int, mat float[][]) RETURNS float[][] AS $$
DECLARE
    resp float[][];
BEGIN
    matlin := array_ndims(mat);
    matcol :=  array_ndims(mat[0]);

    FOR linha IN 0..matlin LOOP
        IF linha <> i THEN
            Resp := array_append(resp, ARRAY[]);
        END IF;
        FOR coluna IN 0..matcol LOOP
            IF linha <> i AND coluna <> j THEN
                resp[linha] := array_append(resp[linha], 0);
            END IF;
        END LOOP;
    END LOOP;
    RETURN resp;
END;
$$ LANGUAGE plpgsql;

