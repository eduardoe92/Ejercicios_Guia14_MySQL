/*Abrir el script de la base de datos llamada “nba.sql” y ejecutarlo para crear todas las tablas e
insertar datos en las mismas. A continuación, generar el modelo de entidad relación. Deberá
obtener un diagrama de entidad relación igual al que se muestra a continuación*/

SELECT 
    *
FROM
    jugadores;
SELECT 
    *
FROM
    equipos;
SELECT 
    *
FROM
    estadisticas;
SELECT 
    *
FROM
    partidos;

#A continuación, se deben realizar las siguientes consultas sobre la base de datos:
#1. Mostrar el nombre de todos los jugadores ordenados alfabéticamente.
SELECT 
    nombre
FROM
    jugadores
ORDER BY nombre ASC;

#2. Mostrar el nombre de los jugadores que sean pivots (‘C’) y que pesen más de 200 libras,
#ordenados por nombre alfabéticamente.
SELECT 
    nombre, peso, posicion
FROM
    jugadores
WHERE
    peso >= 200 AND posicion = 'C'
ORDER BY nombre ASC;
SELECT 
    nombre, peso, posicion
FROM
    jugadores
WHERE
    peso >= 200 AND posicion REGEXP 'C'
ORDER BY nombre ASC;

#3. Mostrar el nombre de todos los equipos ordenados alfabéticamente.
SELECT 
    nombre
FROM
    equipos
ORDER BY nombre ASC;

#4. Mostrar el nombre de los equipos del este (East).
SELECT 
    nombre, conferencia
FROM
    equipos
WHERE
    conferencia = 'East';
SELECT 
    *
FROM
    equipos
WHERE
    conferencia REGEXP 'East';

#5. Mostrar los equipos donde su ciudad empieza con la letra ‘c’, ordenados por nombre.
SELECT 
    nombre, ciudad
FROM
    equipos
WHERE
    ciudad LIKE 'C%'
ORDER BY nombre ASC;

#6. Mostrar todos los jugadores y su equipo ordenados por nombre del equipo.
SELECT 
    nombre, nombre_equipo
FROM
    jugadores
ORDER BY nombre_equipo ASC;

#7. Mostrar todos los jugadores del equipo “Raptors” ordenados por nombre.
SELECT 
    nombre, nombre_equipo
FROM
    jugadores
WHERE
    nombre_equipo = 'Raptors'
ORDER BY nombre ASC;

#8. Mostrar los puntos por partido del jugador ‘Pau Gasol’.
select * from jugadores where nombre='Pau Gasol';
SELECT 
    nombre, puntos_por_partido
FROM
    jugadores AS j
        JOIN
    estadisticas AS e ON j.codigo = e.jugador
WHERE
    j.nombre = 'Pau Gasol';

#9. Mostrar los puntos por partido del jugador ‘Pau Gasol’ en la temporada ’04/05′.
select * from jugadores where nombre='Pau Gasol';
SELECT 
    nombre, puntos_por_partido, e.temporada
FROM
    jugadores AS j
        JOIN
    estadisticas AS e ON j.codigo = e.jugador
WHERE
    j.nombre = 'Pau Gasol'
        AND e.temporada = '04/05';

#10. Mostrar el número de puntos de cada jugador en toda su carrera.
SELECT 
    j.Nombre,
    ROUND(SUM(e.Puntos_por_partido)) AS 'Puntos Totales'
FROM
    estadisticas e
        JOIN
    jugadores j ON e.jugador = j.codigo
GROUP BY j.Nombre;

#11. Mostrar el número de jugadores de cada equipo.
SELECT 
    e.Nombre AS Equipo, COUNT(j.codigo) AS 'Cantidad Jugadores'
FROM
    equipos e
        LEFT JOIN
    jugadores j ON e.Nombre = j.Nombre_equipo
GROUP BY e.Nombre;

#12. Mostrar el jugador que más puntos ha realizado en toda su carrera.
SELECT 
    j.Nombre, ROUND(SUM(e.Puntos_por_partido)) AS Total_Puntos
FROM
    estadisticas e
        JOIN
    jugadores j ON e.jugador = j.codigo
GROUP BY j.Nombre
ORDER BY Total_Puntos DESC
LIMIT 1;

#13. Mostrar el nombre del equipo, conferencia y división del jugador más alto de la NBA.
SELECT 
    *
FROM
    jugadores
ORDER BY altura DESC
LIMIT 1;
select nombre, altura from jugadores order by altura desc limit 1;

SELECT 
    e.nombre, conferencia, division, j.nombre, j.altura
FROM
    equipos AS e
        JOIN
    jugadores AS j ON e.nombre = j.Nombre_equipo
WHERE
    j.Altura = (SELECT 
            MAX(Altura)
        FROM
            jugadores);

#14. Mostrar la media de puntos en partidos de los equipos de la división Pacific.
SELECT 
    e.Nombre AS Equipo,
    AVG(p.puntos_local + p.puntos_visitante) AS Media_Puntos
FROM
    equipos e
        JOIN
    partidos p ON e.Nombre = p.equipo_local
        OR e.Nombre = p.equipo_visitante
WHERE
    e.Division = 'Pacific'
GROUP BY e.Nombre;

#15. Mostrar el partido o partidos (equipo_local, equipo_visitante y diferencia) con mayor diferencia de puntos.
SELECT 
    equipo_local,
    equipo_visitante,
    ABS(puntos_local - puntos_visitante) AS diferencia
FROM
    partidos
WHERE
    ABS(puntos_local - puntos_visitante) = (SELECT 
            MAX(ABS(puntos_local - puntos_visitante))
        FROM
            partidos);

#16. Mostrar la media de puntos en partidos de los equipos de la división Pacific.
SELECT 
    AVG(puntos_local + puntos_visitante) AS Media_Puntos
FROM
    partidos
WHERE
    equipo_local IN (SELECT 
            Nombre
        FROM
            equipos
        WHERE
            Division = 'Pacific')
        OR equipo_visitante IN (SELECT 
            Nombre
        FROM
            equipos
        WHERE
            Division = 'Pacific');

SELECT 
    ROUND(AVG(puntos_local + puntos_visitante)) AS Media_Puntos
FROM
    partidos
WHERE
    equipo_local IN (SELECT 
            Nombre
        FROM
            equipos
        WHERE
            Division = 'Pacific')
        OR equipo_visitante IN (SELECT 
            Nombre
        FROM
            equipos
        WHERE
            Division = 'Pacific');

#17. Mostrar los puntos de cada equipo en los partidos, tanto de local como de visitante.
SELECT 
    e.nombre, p.puntos_local, p.puntos_visitante, temporada
FROM
    equipos AS e
        INNER JOIN
    partidos AS p ON e.nombre = p.equipo_local;

SELECT 
    equipo_local, SUM(puntos_local) AS Puntos_Local
FROM
    partidos
GROUP BY equipo_local 
UNION ALL SELECT 
    equipo_visitante, SUM(puntos_visitante) AS puntos_visitante
FROM
    partidos
GROUP BY equipo_visitante;

SELECT 
    equipos.nombre,
    SUM(partidos.puntos_local) AS puntos_locales,
    SUM(partidos.puntos_visitante) AS puntos_visitantes
FROM
    equipos
        INNER JOIN
    partidos ON equipos.nombre = partidos.equipo_local
GROUP BY equipos.nombre;

#18. Mostrar quien gana en cada partido (codigo, equipo_local, equipo_visitante,
#equipo_ganador), en caso de empate sera null.

SELECT 
    codigo,
    equipo_local,
    equipo_visitante,
    CASE
        WHEN puntos_local > puntos_visitante THEN equipo_local
        WHEN puntos_local < puntos_visitante THEN equipo_visitante
        ELSE NULL
    END AS equipo_ganador
FROM
    partidos;

SELECT 
    codigo,
    equipo_local,
    equipo_visitante,
    IF(puntos_local > puntos_visitante,
        equipo_local,
        IF(puntos_local < puntos_visitante,
            equipo_visitante,
            NULL)) AS equipo_ganador
FROM
    partidos;
