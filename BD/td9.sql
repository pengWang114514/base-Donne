set serveroutput on;
--1)
--a)
create or replace function nbFilms (idPers IN ens2004.individu.numindividu%type)
return number is nb number;
begin 
select count(*) into nb
from ens2004.acteur
where numindividu=idPers;
return (nb);
end;


--b)

create or replace procedure afficher(idPers in ens2004.individu.numindividu%type) 
is

cursor leslibelles is 
select libellegenre, count(*) as nb
from ens2004.genre
natural join ens2004.genrefilm
natural join ens2004.acteur
where numindividu=idPers
group by libellegenre;

begin
for laligne in leslibelles
loop
(laligne.libellegenre||'-'||laligne.nb);
end loop;

end;

--c)
create or replace procedure afficherNom(nomPers in ens2004.individu.nomindividu%type)
is 

cursor lesacteurs is 
select *
from ens2004.individu
where nomindividu = nomPers;

begin
for unacteur in lesacteurs
loop
DBMS_OUTPUT.PUT_LINE(unacteur.prenomindividu||' '||unacteur.nomindividu||' '||'a jou� dans');
afficher(unacteur.numindividu);
DBMS_OUTPUT.PUT_LINE('======================');
end loop;

end;


--2)

--a)
create or replace procedure acteursde2(idfilm in ens2004.film.numfilm%type) 
is

cursor lesacteurs is
select *
from ens2004.individu
natural join ens2004.acteur
where numfilm = idfilm;

begin
for unacteur in lesacteurs
loop
DBMS_OUTPUT.PUT_LINE(unacteur.prenomindividu||' '||unacteur.nomindividu);
end loop;
end;


--b)
create or replace procedure ActeurDe(titreF in ens2004.film.titre%type) is

num ens2004.film.numfilm%type;

begin
select numfilm into num
from ens2004.film
where titre = titreF;
DBMS_OUTPUT.PUT_LINE('les acteurs de '||titreF||' sont :');
acteursde2(num);

exception 
when too_many_rows then DBMS_OUTPUT.PUT_LINE('Il y a plusieurs film avec ce titre');
when no_data_found then DBMS_OUTPUT.PUT_LINE('aucun film avec ce titre');
end;




--c)
create or replace procedure RealDe(numP in ens2004.individu.numindividu%type) is
nom ens2004.individu.nomindividu%type;
prenom ens2004.individu.prenomindividu%type;

begin
select nomindividu, prenomindividu into nom, prenom
from ens2004.individu
where numP = numindividu;
DBMS_OUTPUT.PUT_LINE(prenom || ' '|| nom);
end;

create or replace procedure ActeurDe(titreF in ens2004.film.titre%type) is

titrelong ens2004.film.titre%type;

cursor lesfilms is
select numfilm, titre, realisateur
from ens2004.film
where titre like titrelong;

begin
titrelong := concat(titreF, '%');
titrelong := concat('%', titreF);
for lefilm in lesfilms
loop

DBMS_OUTPUT.PUT_LINE('les acteurs de '||lefilm.titre||' sont :');
acteursde2(lefilm.numfilm);
DBMS_OUTPUT.PUT_LINE('realise par : ');
RealDe(lefilm.realisateur);
end loop;

end;
