# Sistema Electoral

Base de datos relacional desarrollada con MySQL, se trata de un proyecto donde se imita le funcionamiento de un sistema de elecciones nacionales.

## Tablas

Esta base de datos cuenta con 4 tablas estructuradas de la siguiente forma:

#### &nbsp;&nbsp;&nbsp;&nbsp; • Votantes

| Field    | Type    | Extra          | Key     |
|----------|---------|----------------|---------|
| id       | int     | auto_increment | PRIMARY |
| nombre   | varchar |                |         |
| apellido | varchar |                |         |
| dni      | varchar |                |         |

#### &nbsp;&nbsp;&nbsp;&nbsp; • Partidos Políticos

| Field     | Type    | Extra          | Key     |
|-----------|---------|----------------|---------|
| id        | int     | auto_increment | PRIMARY |
| nombre    | varchar |                |         |
| lider     | varchar |                |         |
| ideologia | varchar |                |         |

#### &nbsp;&nbsp;&nbsp;&nbsp; • Candidatos

| Field      | Type    | Extra          | Key     |
|------------|---------|----------------|---------|
| id         | int     | auto_increment | PRIMARY |
| nombre     | varchar |                |         |
| apellido   | varchar |                |         |
| id_partido | int     |                | FOREIGN |

#### &nbsp;&nbsp;&nbsp;&nbsp; • Votos

| Field        | Type | Extra          | Key     |
|--------------|------|----------------|---------|
| id           | int  | auto_increment | PRIMARY |
| id_votante   | int  |                | FOREIGN |
| id_candidato | int  |                | FOREIGN |
| fecha        | date |                |         |

## Tareas
Las tareas de este sistema de base de datos relacional desarrollado con MySQL son:

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear una base de datos llamada "sistema_electoral" que contenga las siguientes tablas: votantes(id, nombre, apellido, dni) - partidos_politicos(id, nombre, lider, ideologia) - candidatos (id, nombre, apellido, id_partido) - votos(id, id_votante, id_candidato, fecha).

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Insertar algunos datos en cada tabla.

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear una consulta que muestre todos los votantes registrados en la base de datos.

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear una consulta que muestre todos los candidatos registrados en la base de datos, con su respectivo partido político.

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear una consulta que muestre todos los candidatos registrados en la base de datos, con su respectivo partido político.
 
 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear una consulta que muestre todos los votos registrados en la base de datos.

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear una función que permita calcular la cantidad de votos que ha recibido un candidato determinado.

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear un disparador que se active cada vez que se inserte un nuevo voto en la tabla "votos" y que actualice la cantidad de votos recibidos por el candidato correspondiente en la tabla "candidatos".

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear una consulta que muestre los resultados de una votación, indicando la cantidad de votos recibidos por cada candidato y por cada partido político.
 
 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear un procedimiento almacenado que permita eliminar un votante de la tabla "votantes" y todos sus votos correspondientes en la tabla "votos".

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear una consulta que muestre el candidato ganador de la elección.
 
 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear una consulta que muestre el partido político con más votos en la elección

 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear un disparador que se active cada vez que se inserte un nuevo voto en la tabla "votos" y verifique que el votante correspondido no haya votado anteriormente en la misma elección.
 
 #### &nbsp;&nbsp;&nbsp;&nbsp; • Crear un procedimiento almacenado que permita registrar un nuevo partido político en la tabla "partidos_politicos", con la posibilidad de agregar varios candidatos de una sola vez en la tabla "candidatos".
