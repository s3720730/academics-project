/*Use an IN subquery to find the title, given name and family name of all academics who
work in departments located in Queensland.
(Postcodes for Queensland start with the digit 4)*/

SELECT title, givename, famname
FROM Academic
WHERE deptnum IN (SELECT deptnum FROM Department WHERE postcode LIKE '4%');

/*Using joins only, list all the title of fields of interest to doctors that work in Queensland.
Output the field names, without duplicates. Do not use Natural Join for this question.*/

SELECT Field.title
FROM (((Field JOIN Interest ON Field.fieldnum = Interest.fieldnum)
JOIN Academic ON Interest.acnum = Academic.acnum)
JOIN Department ON Academic.deptnum = Department.deptnum)
WHERE lower(Department.state) LIKE 'qld'
GROUP BY Field.title;

/*Display a list of academics that have collaborated with another academic on more than
one paper. List individual pairs of academics on each line. List only their academic
numbers. Do not list duplicate pairs. (e.g 56,113 and 113,56 are duplicate pairs)*/

SELECT a1.acnum, a2.acnum
FROM Author a1, Author a2
WHERE a1.panum = a2.panum AND a1.acnum < a2.acnum
GROUP BY a1.acnum, a2.acnum
HAVING count(a1.panum = a2.panum)>1;

/*There are some academics that have written more than 12 papers and there are some
academics are interested in fields that have the word “database” in the title. List the
academic number of each academic that meet either or both of these conditions.*/

SELECT acnum
FROM Author
GROUP BY acnum
HAVING count(panum) > 12
UNION
SELECT acnum
FROM Interest NATURAL JOIN Field
WHERE lower(Field.title) LIKE '%database%';

/*There is concern about the integrity of the data in the Academics table. Are there any
academics in the database who are missing Initials or a Title? Write a query to list the
academic number of any academics that do not have initials or a title. Do not use a
sub-query.*/

SELECT acnum
FROM Academic
WHERE title IS NULL OR initials IS NULL;

/*Find all academics who have an interest in the field titled “Natural Language
Processing”. You must use an EXISTS sub-query. Output the initials of these
academics. HINT : Don’t forget to use TRIM when testing the title.*/

SELECT initials
FROM Academic
WHERE EXISTS (SELECT acnum
FROM Interest JOIN Field ON Interest.fieldnum = Field.fieldnum
WHERE trim(Field.title) LIKE 'Natural Language Processing' AND Interest.acnum = Academic.acnum);

/*Further limit this list of academics by adding a NOT EXISTS condition test so only
academics who have no other interests other than “Natural Language
Processing” are present in the output.*/

SELECT initials
FROM Academic
WHERE EXISTS (SELECT acnum
FROM Interest JOIN Field ON Interest.fieldnum = Field.fieldnum
WHERE trim(Field.title) LIKE 'Natural Language Processing' AND Interest.acnum = Academic.acnum)
AND NOT EXISTS (SELECT count(fieldnum)
FROM Interest
GROUP BY acnum
HAVING count(fieldnum)>1 AND Interest.acnum = Academic.acnum);

/*Write an SQL query to create a View that displays the title and surname of each
academic and how many papers they have written. If an academic have not written any
papers, then a “0” should be displayed against their name.*/

CREATE VIEW [Number of Papers Per Academic] AS
SELECT Academic.title, Academic.famname, count(panum)
FROM Author JOIN Academic on Academic.acnum = Author.acnum
GROUP BY Author.acnum;



