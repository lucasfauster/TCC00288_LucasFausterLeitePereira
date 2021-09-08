create table atividade(
id int not null primary key,
nome varchar not null
);

create table artista(
id int not null primary key,
nome varchar not null,
rua varchar not null, 
cidade varchar not null, 
estado varchar not null, 
cep varchar not null, 
atividade int not null,
foreign key (atividade) references atividade(id)
);


create table arena(
id int not null primary key,
nome varchar not null,
cidade varchar not null, 
capacidade int not null 
);

create table concerto(
id int not null primary key,
artista int not null,
arena int not null, 
inicio timestamp not null, 
fim timestamp not null, 
preco decimal not null,
foreign key (artista) references artista(id),
foreign key (arena) references arena(id)
);

insert into atividade values (1,'Canto');
insert into artista values (1,'Lucas', 'Otavio', 'Rio de Janeiro', 'Rio de Janeiro', '123123-32', 1);
insert into arena values (1,'Maracana', 'Rio de Janeiro', 10000);
insert into concerto values (1, 1, 1, current_timestamp, current_timestamp + interval '3 hours', 32.5);

CREATE OR REPLACE FUNCTION estao_ocupados() RETURNS trigger AS $$
    DECLARE
        arena_block int = 0;
    BEGIN
    
        SELECT COUNT(*) INTO arena_block FROM concerto c
        WHERE (c.arena = NEW.arena OR c.artista = NEW.artista) AND 
              (NEW.inicio BETWEEN c.inicio AND c.fim OR NEW.fim BETWEEN c.inicio AND c.fim);
        
        IF arena_block <> 0 THEN
            RAISE EXCEPTION 'Conflito na agenda da arena ou do artista';
        END IF;

        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER estao_ocupados BEFORE INSERT ON concerto
    FOR EACH ROW EXECUTE FUNCTION estao_ocupados();

CREATE OR REPLACE FUNCTION block_artista() RETURNS trigger AS $$
    DECLARE
        artista_qtd int = 0;
    BEGIN

        SELECT COUNT(*) INTO artista_qtd 
        FROM artista a
        WHERE a.atividade = old.atividade;
        
        IF artista_qtd <= 1 THEN
            RAISE EXCEPTION 'Deve haver pelo menos 1 artista nesta atividade!';
        END IF;

        RETURN OLD;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER block_artista BEFORE DELETE ON artista
    FOR EACH ROW EXECUTE FUNCTION block_artista();
