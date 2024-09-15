--SCRIPT DE COMANDOS DEL CURSO

-- SELECCIONAR COLUMNAS

SELECT title
FROM articles;

SELECT Title, Authors, ISSNs, Year, DOI
FROM articles;

SELECT *
FROM articles;

-- VALORES UNICOS

SELECT DISTINCT ISSNs
FROM articles;

-- Cuando se usan varias columanas escoge pares de valores unicos
SELECT DISTINCT ISSNs, Day, Month, Year
FROM articles;

-- ORDENAR FILAS

-- Ascendente
SELECT *
FROM articles
ORDER BY ISSNs ASC;

--Descendente
SELECT *
FROM articles
ORDER BY First_Author DESC;

--Multiples columnas
SELECT *
FROM articles
ORDER BY ISSNs DESC, First_Author ASC;

-- Ejercicio: Escriba una consulta que devuelva Title, First_Author, ISSNsy Citation_Countde la tabla de artículos, ordenados por el artículo más citado y alfabéticamente por título.

-- FILTROS

-- Filtro de un valor especifico
SELECT *
FROM articles
WHERE ISSNs = '2056-9890';

-- Filtro de multiples condiciones que se cumplan simultaneamente (AND)
SELECT *
FROM articles
WHERE (ISSNs = '2056-9890') AND (Month > 10);

--- Filtro de multiples condiciones que se cumpla al menos una (OR)
SELECT *
FROM articles
WHERE (ISSNs = '2076-0787') OR (ISSNs = '2077-1444');

--- Filtro de busquedas parciales 
 
SELECT *
FROM articles
WHERE Subjects LIKE '%Crystal Structure%';

--- Ejercicio: Escriba una consulta que devuelva Title, First_Author, Subjects, ISSNsy Monthpara Yeartodos los artículos que Subjectscontengan “computadora” y que tengan más de 8 citas.


--- ORDEN DE EJECUCION

--- ¿Por qué podemos ordenar utilizando la columna First_Author cuando no está incluida en la tabla final?
SELECT Title, Authors
FROM articles
WHERE ISSNs = '2067-2764|2247-6202'
ORDER BY First_Author ASC;

---CONSULTAS COMPLEJAS Y COMENTARIOS (REVISAR EN EL MATERIAL)

--- AGREGACION

--- Aplicar una funcion sobre una columna resultante (resumir)
SELECT ISSNs, AVG(Citation_Count)
FROM articles
GROUP BY ISSNs;

--- Ordenar la columna calculada 
SELECT ISSNs, AVG(Citation_Count)
FROM articles
GROUP BY ISSNs 
ORDER BY AVG(Citation_Count) DESC;

--- Ejercicio: Escriba una consulta utilizando una función de agregación que devuelva la cantidad de títulos de artículos por ISSN, ordenados por cantidad de títulos en orden descendente. ¿Qué ISSN tiene más títulos? (Sugerencia para elegir qué función de agregación utilizar: es una de las funciones de agregación más comunes MAX, MIN, AVG, COUNT, SUM).

--- HAVING

--- Filtrar los resultados agregados
SELECT ISSNs, COUNT(*)
FROM articles
GROUP BY ISSNs
HAVING COUNT(Title) >= 10;

--- Ejercicio: Escriba una consulta que devuelva, de la articlestabla, el promedio Citation_Countpara cada ISSN de revista pero sólo para las revistas con 5 o más citas en promedio.

--- CALCULOS

--- Sumas y restas
SELECT Title, ISSNs, Author_Count - 1 as CoAuthor_Count
FROM articles
ORDER BY CoAuthor_Count DESC;

--- Multiplicaciones *
--- SELECT 1.05 * reading FROM Survey WHERE quant = 'rad';

--- Redondeo ROUND
/*SELECT taken, round(5 * (reading - 32) / 9, 2) as Celsius FROM Survey WHERE quant = 'temp';*/

--- Concatenar 
SELECT First_Author || ' ' || 'et al.,' || ' ' || Year AS cita FROM articles;

--- UNIONES

--- Inner join 
SELECT *
FROM articles
JOIN journals
ON articles.ISSNs = journals.ISSNs;

SELECT *
FROM articles
JOIN journals
USING (ISSNs); --- Cuando ambas tablas tienen el mismo nombre

--- Otros tipos de uniones: LEFT JOIN, RIGHT JOIN, FULL JOIN

--- Seleccion de columnas y uniones 
SELECT articles.ISSNs, journals.Journal_Title, articles.Title,
       articles.First_Author, articles.Month, articles.Year
FROM articles
JOIN journals
ON articles.ISSNs = journals.ISSNs;

--- Uniones y operaciones agrupadas
SELECT articles.ISSNs, journals.Journal_Title,
       ROUND(AVG(articles.Author_Count), 2)
FROM articles
JOIN journals
ON articles.ISSNs = journals.ISSNs
GROUP BY articles.ISSNs;

--- Ejercicio: Write a query that JOINS the articles and journals tables and that returns the Journal_Title, total number of articles published and average number of citations for every journal ISSN.

--- Multiples tablas
SELECT articles.Title, articles.First_Author, journals.Journal_Title, publishers.Publisher
FROM articles
JOIN journals
ON articles.ISSNs = journals.ISSNs
JOIN publishers
ON publishers.id = journals.PublisherId;

---Ejercicio: Write a query that returns the Journal_Title, Publisher name, and number of articles published, ordered by number of articles in descending order.

--- ALIASES

--- Aliases para las tablas
SELECT ar.Title, ar.First_Author, jo.Journal_Title
FROM articles AS ar
JOIN journals AS jo
ON ar.ISSNs = jo.ISSNs;

--- Aliases para las columnas
SELECT ar.title AS title,
       ar.first_author AS author,
       jo.journal_title AS journal
FROM articles AS ar
JOIN journals AS jo
ON ar.issns = jo.issns;

--- Aliases sin utilizar el comando AS
SELECT a.Title t
FROM articles a;

--- SAVING QUERIES

CREATE VIEW journal_counts AS
SELECT ISSNs, COUNT(*)
FROM articles
GROUP BY ISSNs;

SELECT *
FROM journal_counts;

DROP VIEW journal_counts;

---Ejercicio: Escribe una consulta CREATE VIEW que UNA la tabla de artículos con la tabla de revistas en ISSNs y devuelva el CONTADOR de registros de artículos agrupados por el Título de la Revista en orden DESC.

