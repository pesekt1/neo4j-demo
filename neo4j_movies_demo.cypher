/* Return all nodes in the database */
MATCH (n)-[r]-(m)
RETURN n, r, m;

/* Find all movies directed by Ron Howard */
MATCH (movie:Movie)<-[:DIRECTED]-(person:Person)
WHERE person.name = 'Ron Howard'
RETURN movie;

/* Create a new Person node named Adam */
CREATE (friend:Person {name: 'Adam'})
RETURN friend;

/* Create two Person nodes and a LOVES relationship between Ann and Dan */
CREATE (ann:Person {name: 'Ann'})-[:LOVES]->(dan:Person {name: 'Dan'});

/* Create a friendship relationship between Jennifer and Ann */
MATCH (jennifer:Person {name: 'Jennifer'})
MATCH (ann:Person {name: 'Ann'})
CREATE (jennifer)-[:IS_FRIENDS_WITH]->(ann);

/* Set birthdate property for Jennifer */
MATCH (p:Person {name: 'Jennifer'})
SET p.birthdate = date('1980-01-01')
RETURN p;

/* Set startYear property for Jennifer's WORKS_FOR relationship to Neo4j */
MATCH (:Person {name: 'Jennifer'})-[rel:WORKS_FOR]->(:Company {name: 'Neo4j'})
SET rel.startYear = 2018
RETURN rel;

/* Create indexes on Person born and Movie released properties */
CREATE INDEX person_born IF NOT EXISTS
FOR (p:Person)
ON (p.born);
CREATE INDEX movie_released IF NOT EXISTS
FOR (m:Movie)
ON (m.released);

/* Find the Person node for Tom Hanks */
MATCH (p:Person {name: "Tom Hanks"})
RETURN p;

/* Return the names of the first 10 Person nodes */
MATCH (p:Person)
RETURN p.name
LIMIT 10;

/* Return the first 10 Person nodes */
MATCH (p:Person)
RETURN p
LIMIT 10;

/* Find all movies released in the 1990s */
MATCH (m:Movie)
WHERE m.released >= 1990 AND m.released < 2000
RETURN m.title, m.released;

/* Find all movies acted in by Tom Hanks */
MATCH (p:Person {name: "Tom Hanks"})-[:ACTED_IN]->(movie)
RETURN p.movie;

/* Find all co-actors of Tom Hanks */
MATCH (:Person {name: "Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors)
RETURN coActors.name;

/* Return the paths from Tom Hanks to his co-actors */
MATCH
  path = (:Person {name: "Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors)
RETURN path;

/* Find all relationships of people who acted in "Cloud Atlas" */
MATCH (p:Person)-[relationship]-(:Movie {title: "Cloud Atlas"})
RETURN p.name, type(relationship), relationship;

/* Find all nodes within 6 degrees of separation from Kevin Bacon */
MATCH (:Person {name: "Kevin Bacon"})-[*1..6]-(n)
RETURN DISTINCT n;

/* Find the shortest path between Kevin Bacon and Meg Ryan */
MATCH
  path =
    SHORTESTPATH
    (
    (:Person {name: "Kevin Bacon"})-[*]-
    (:Person {name: "Meg Ryan"}))
RETURN path, length(path) / 2 AS distance;

/* Recommend actors to Tom Hanks based on co-actors of his co-actors */
MATCH
  (p:Person {name: "Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors),
  (coActors)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cocoActors)
WHERE
  NOT EXISTS { (p)-[:ACTED_IN]->()<-[:ACTED_IN]-(cocoActors) } AND
  p <> cocoActors
RETURN cocoActors.name AS recommended, count(*) AS score
ORDER BY score DESC;

/* Find matchmakers who have worked with both Tom Hanks and Keanu Reeves */
MATCH
  (p1:Person {name: "Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActors),
  (coActors)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(p2:Person {name: "Keanu Reeves"})
RETURN DISTINCT coActors.name AS matchmaker;

/* Example: Find all friends-of-friends for a person (multi-hop traversal) */
MATCH (p:Person {name: 'Ann'})-[:IS_FRIENDS_WITH*2]-(fof)
RETURN fof;

/* Example: Find shortest path between two people */
MATCH
  (a:Person {name: 'Ann'}),
  (b:Person {name: 'Dan'}),
  p = SHORTESTPATH ((a)-[*]-(b))
RETURN p;

/* Example: Find all movies connected to a person by any relationship */
MATCH (p:Person {name: 'Keanu Reeves'})-[*]-(m:Movie)
RETURN m;

/* Example: Find all people who acted in movies directed by Ron Howard */
MATCH
  (director:Person {name: 'Ron Howard'})-[:DIRECTED]->
  (movie)<-[:ACTED_IN]-
  (actor)
RETURN actor, movie;

/* Delete all nodes and relationships in the database */
MATCH (n:Person|Movie)
DETACH DELETE n;

/* Count all nodes in the database */
MATCH ()
RETURN count(*);