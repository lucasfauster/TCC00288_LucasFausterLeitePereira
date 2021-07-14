drop if exists campeonato cascade;
CREATE TABLE campeonato(
    codigo text NOT NULL,
    nome text NOT NULL,
    ano integer NOT NULL,
    CONSTRAINT campeonato_pk PRIMARY KEY
    (codigo));

drop if exists time_ cascade;
CREATE TABLE time_(
    sigla text NOT NULL,
    nome text NOT NULL,
    CONSTRAINT time_pk PRIMARY KEY
    (sigla));

drop if exists jogo cascade;
CREATE TABLE jogo(
    campeonato text NOT NULL,
    numero integer NOT NULL,
    time1 text NOT NULL,
    time2 text NOT NULL,
    gols1 integer NOT NULL,
    gols2 integer NOT NULL,
    date_ date NOT NULL,
    CONSTRAINT jogo_pk PRIMARY KEY
    (campeonato,numero),
    CONSTRAINT jogo_campeonato_fk FOREIGN KEY
    (campeonato) REFERENCES campeonato(codigo),
    CONSTRAINT jogo_time_fk1 FOREIGN KEY
    (time1) REFERENCES time_ (sigla),
    CONSTRAINT jogo_time_fk2 FOREIGN KEY
    (time2) REFERENCES time_ (sigla));

CREATE FUNCTION tabelaCampeonato(campeonato int, pos1 int, pos2 int) RETURNS TABLE(nome text, pontos int) AS $$
DECLARE
    maior int;
    i int;
BEGIN
    i := pos2-pos1;
    FOR 0..i LOOP
        
    END LOOP;
END;
$$ LANGUAGE plpgsql;