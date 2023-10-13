CREATE TABLE IF NOT EXISTS INSCRITOS(cantidad INT, fecha DATE, fuente
VARCHAR);
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 44, '01/01/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 56, '01/01/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 39, '01/02/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 81, '01/02/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 12, '01/03/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 91, '01/03/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 48, '01/04/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 45, '01/04/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 55, '01/05/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 33, '01/05/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 18, '01/06/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 12, '01/06/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 34, '01/07/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 24, '01/07/2021', 'Página' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 83, '01/08/2021', 'Blog' );
INSERT INTO INSCRITOS(cantidad, fecha, fuente)
VALUES ( 99, '01/08/2021', 'Página' );
--¿Cuántos registros hay?¿Cuántos registros hay?
SELECT count(*) FROM INSCRITOS;
--¿Cuántos inscritos hay en total?
SELECT SUM(cantidad) AS total_inscritos
FROM INSCRITOS;
--¿Cuál o cuáles son los registros de mayor antigüedad?
SELECT * FROM INSCRITOS
WHERE fecha = (SELECT MIN(fecha) FROM INSCRITOS);
/*¿Cuántos inscritos hay por día? (entendiendo un día como una fecha distinta de
ahora en adelante)*/
SELECT fecha, COUNT(*) AS inscritos_dia
FROM INSCRITOS
GROUP BY fecha;
--¿Cuántos inscritos hay por fuente?
SELECT fuente, COUNT(*) AS inscritos_fuente
FROM INSCRITOS
GROUP BY fuente;
/*¿Qué día se inscribió la mayor cantidad de personas? ¿Cuántas personas se
inscribieron en ese día?*/
SELECT fecha, MAX(cantidad_por_dia) 
FROM (
    SELECT fecha, SUM(cantidad) AS cantidad_por_dia
    FROM INSCRITOS
    GROUP BY fecha
) AS maximo
GROUP BY fecha
HAVING MAX(cantidad_por_dia) = (
    SELECT MAX(cantidad_por_dia)
    FROM (
        SELECT fecha, SUM(cantidad) AS cantidad_por_dia
        FROM INSCRITOS
        GROUP BY fecha
    ) AS maximo_interno
);
/*¿Qué días se inscribieron la mayor cantidad de personas utilizando el blog? ¿Cuántas
personas fueron?*/
SELECT fecha, SUM(cantidad) AS cantidad_personas
FROM INSCRITOS
WHERE fuente = 'Blog'
GROUP BY fecha
ORDER BY cantidad_personas DESC
LIMIT 1;
--¿Cuál es el promedio de personas inscritas por día?
SELECT fecha, AVG(cantidad) AS promedio_personas
FROM INSCRITOS
GROUP BY fecha;
--¿Qué días se inscribieron más de 50 personas?
SELECT fecha, SUM(cantidad) AS totaL
FROM INSCRITOS
GROUP BY fecha
HAVING SUM(cantidad) > 50
ORDER BY total;
/* ¿Cuál es el promedio diario de personas inscritas a partir del tercer día en adelante,
considerando únicamente las fechas posteriores o iguales a la indicada?*/
SELECT fecha, AVG(cantidad) AS promedio_personas
FROM INSCRITOS
WHERE fecha >= '2021-03-01'
GROUP BY fecha;