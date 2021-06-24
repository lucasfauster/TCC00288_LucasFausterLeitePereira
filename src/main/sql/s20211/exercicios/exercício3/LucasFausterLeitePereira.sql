CREATE FUNCTION multiplicaMatrizes(mat1 float[][], mat2 float[][]) RETURNS float[][] AS $$
DECLARE
    resp float[][];
    mat1lin int;
    mat1col int;
    mat2lin int;
    mat2col int;
BEGIN
    mat1lin := array_ndims(mat1);
    mat1col :=  array_ndims(mat1[0]);
    mat2lin := array_ndims(mat2);
    mat2col :=  array_ndims(mat2[0]);

    IF mat1lin <> mat2col THEN
        RAISE 'Matrizes imcompativeis!';
    END IF;

    FOR linha IN 0..mat1lin LOOP
        resp := array_append(resp, ARRAY[]);
        FOR coluna IN 0..mat2col LOOP
            resp[linha] := array_append(resp[linha], 0);
            FOR v IN 0..mat1col LOOP
                resp[linha][coluna] += mat1[linha][k] * mat2[k][coluna];
            END LOOP;
        END LOOP;
    END LOOP;
    RETURN resp;
END;
$$ LANGUAGE plpgsql;

