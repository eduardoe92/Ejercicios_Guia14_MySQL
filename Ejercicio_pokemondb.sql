/*Importar el script de la base de datos llamada “pokemondb.sql” y ejecutarlo para crear todas
las tablas e insertar los registros en las mismas. A continuación, generar el modelo de entidad
relación y reorganizar las tablas para mayor claridad de sus relaciones. Deberá obtener un
diagrama de entidad de relación similar al que se muestra a continuación:*/

SELECT 
    *
FROM
    pokemon;

#A continuación, se deben realizar las siguientes consultas:
#1. Mostrar el nombre de todos los pokemon.

SELECT 
    nombre
FROM
    pokemon;

#2. Mostrar los pokemon que pesen menos de 10k.

SELECT 
    nombre, peso
FROM
    pokemon
WHERE
    peso < 10;

#3. Mostrar los pokemon de tipo agua.
SELECT 
    p.numero_pokedex, p.nombre, p.peso, p.altura
FROM
    pokemon p
        JOIN
    pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex
        JOIN
    tipo t ON pt.id_tipo = t.id_tipo
WHERE
    t.nombre = 'Agua';

#4. Mostrar los pokemon de tipo agua, fuego o tierra ordenados por tipo.
SELECT 
    p.numero_pokedex,
    p.nombre,
    p.peso,
    p.altura,
    t.nombre AS tipo
FROM
    pokemon p
        JOIN
    pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex
        JOIN
    tipo t ON pt.id_tipo = t.id_tipo
WHERE
    t.nombre IN ('Agua' , 'Fuego', 'Tierra')
ORDER BY t.nombre;

#5. Mostrar los pokemon que son de tipo fuego y volador.
SELECT 
    p.numero_pokedex, p.nombre, p.peso, p.altura
FROM
    pokemon p
        JOIN
    pokemon_tipo pt1 ON p.numero_pokedex = pt1.numero_pokedex
        JOIN
    tipo t1 ON pt1.id_tipo = t1.id_tipo
        JOIN
    pokemon_tipo pt2 ON p.numero_pokedex = pt2.numero_pokedex
        JOIN
    tipo t2 ON pt2.id_tipo = t2.id_tipo
WHERE
    t1.nombre = 'fuego'
        AND t2.nombre = 'volador';

#6. Mostrar los pokemon con una estadística base de ps mayor que 200.
SELECT 
    p.numero_pokedex, p.nombre, p.peso, p.altura, eb.ps
FROM
    pokemon p
        JOIN
    estadisticas_base eb ON p.numero_pokedex = eb.numero_pokedex
WHERE
    eb.ps > 200;

#7. Mostrar los datos (nombre, peso, altura) de la prevolución de Arbok.
SELECT 
    p.nombre, p.peso, p.altura
FROM
    pokemon p
        JOIN
    evoluciona_de e ON p.numero_pokedex = e.pokemon_origen
        JOIN
    pokemon p2 ON e.pokemon_evolucionado = p2.numero_pokedex
WHERE
    p2.nombre = 'Arbok';

#8. Mostrar aquellos pokemon que evolucionan por intercambio.
SELECT 
    *
FROM
    pokemon p
        JOIN
    forma_evolucion fe ON p.numero_pokedex = fe.id_forma_evolucion
        JOIN
    tipo_evolucion te ON fe.tipo_evolucion = te.id_tipo_evolucion
WHERE
    te.tipo_evolucion = 'Intercambio';

#9. Mostrar el nombre del movimiento con más prioridad.
SELECT 
    nombre
FROM
    movimiento
WHERE
    prioridad = (SELECT 
            MAX(prioridad)
        FROM
            movimiento);

#10. Mostrar el pokemon más pesado.
SELECT 
    nombre, peso
FROM
    pokemon
WHERE
    (SELECT 
            MAX(peso)
        FROM
            pokemon)
ORDER BY peso DESC
LIMIT 1;

#11. Mostrar el nombre y tipo del ataque con más potencia.
SELECT 
    m.nombre, t.nombre AS tipo
FROM
    movimiento m
        JOIN
    tipo t ON m.id_tipo = t.id_tipo
WHERE
    m.potencia = (SELECT 
            MAX(potencia)
        FROM
            movimiento);

#12. Mostrar el número de movimientos de cada tipo.
SELECT 
    t.nombre AS tipo, COUNT(*) AS cantidad_movimientos
FROM
    movimiento m
        JOIN
    tipo t ON m.id_tipo = t.id_tipo
GROUP BY t.nombre
ORDER BY cantidad_movimientos DESC;

#13. Mostrar todos los movimientos que puedan envenenar.
SELECT 
    m.nombre AS movimiento
FROM
    movimiento m
        JOIN
    movimiento_efecto_secundario mes ON m.id_movimiento = mes.id_movimiento
        JOIN
    efecto_secundario es ON mes.id_efecto_secundario = es.id_efecto_secundario
WHERE
    es.efecto_secundario = 'Envenenar';

#14. Mostrar todos los movimientos que causan daño, ordenados alfabéticamente por nombre.
SELECT 
    nombre
FROM
    movimiento
WHERE
    potencia > 0
ORDER BY nombre ASC;

#15. Mostrar todos los movimientos que aprende pikachu.
SELECT 
    m.nombre AS movimiento
FROM
    pokemon p
        JOIN
    pokemon_movimiento_forma pmf ON p.numero_pokedex = pmf.numero_pokedex
        JOIN
    movimiento m ON pmf.id_movimiento = m.id_movimiento
WHERE
    p.numero_pokedex = 25;

#16. Mostrar todos los movimientos que aprende pikachu por MT (tipo de aprendizaje).
SELECT 
    m.nombre AS movimiento
FROM
    pokemon p
        JOIN
    pokemon_movimiento_forma pmf ON p.numero_pokedex = pmf.numero_pokedex
        JOIN
    movimiento m ON pmf.id_movimiento = m.id_movimiento
        JOIN
    forma_aprendizaje fa ON pmf.id_forma_aprendizaje = fa.id_forma_aprendizaje
        JOIN
    MT mt ON fa.id_forma_aprendizaje = mt.id_forma_aprendizaje
WHERE
    p.numero_pokedex = 25;

#17. Mostrar todos los movimientos de tipo normal que aprende pikachu por nivel.
SELECT 
    m.nombre AS movimiento
FROM
    pokemon p
        JOIN
    pokemon_movimiento_forma pmf ON p.numero_pokedex = pmf.numero_pokedex
        JOIN
    movimiento m ON pmf.id_movimiento = m.id_movimiento
        JOIN
    forma_aprendizaje fa ON pmf.id_forma_aprendizaje = fa.id_forma_aprendizaje
        JOIN
    nivel_aprendizaje na ON fa.id_forma_aprendizaje = na.id_forma_aprendizaje
        JOIN
    tipo t ON m.id_tipo = t.id_tipo
WHERE
    p.numero_pokedex = 25
        AND t.nombre = 'Normal';

#18. Mostrar todos los movimientos de efecto secundario cuya probabilidad sea mayor al 30%.
SELECT 
    m.nombre AS movimiento, mes.probabilidad
FROM
    movimiento m
        JOIN
    movimiento_efecto_secundario mes ON m.id_movimiento = mes.id_movimiento
WHERE
    mes.probabilidad > 0.3;

#19. Mostrar todos los pokemon que evolucionan por piedra.
SELECT 
    p.numero_pokedex, p.nombre
FROM
    pokemon p
        JOIN
    pokemon_forma_evolucion pfe ON p.numero_pokedex = pfe.numero_pokedex
        JOIN
    forma_evolucion fe ON pfe.id_forma_evolucion = fe.id_forma_evolucion
        JOIN
    tipo_evolucion te ON fe.tipo_evolucion = te.id_tipo_evolucion
WHERE
    LOWER(te.tipo_evolucion) = 'piedra';

#20. Mostrar todos los pokemon que no pueden evolucionar.
SELECT 
    p.numero_pokedex, p.nombre
FROM
    pokemon p
        LEFT JOIN
    evoluciona_de ev ON p.numero_pokedex = ev.pokemon_origen
WHERE
    ev.pokemon_evolucionado IS NULL;

#21. Mostrar la cantidad de los pokemon de cada tipo.
SELECT 
    t.nombre AS tipo, COUNT(*) AS cantidad
FROM
    pokemon p
        JOIN
    pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex
        JOIN
    tipo t ON pt.id_tipo = t.id_tipo
GROUP BY t.nombre;
