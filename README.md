# Neo4j Movie Graph Demo

## Overview

This demo showcases the power of graph databases using Neo4j and a movie dataset. You will learn how to set up Neo4j with Docker, seed it with Cypher scripts, and run queries that highlight the strengths of graph databases compared to traditional relational databases.

## What is Neo4j?

Neo4j is a popular graph database that stores data as nodes (entities) and relationships (connections between entities). Unlike relational databases, which use tables and foreign keys, Neo4j is designed for highly connected data and complex queries involving relationships.

### Key Concepts

- **Node**: An entity, such as a person or a movie.
- **Relationship**: A connection between nodes, such as "ACTED_IN" or "DIRECTED".
- **Cypher**: Neo4j's query language, optimized for graph operations.

## Why Use a Graph Database?

Graph databases excel at handling data with complex relationships. They are much faster and more intuitive for queries that involve traversing connections, such as social networks, recommendation engines, and fraud detection.

## Setup Instructions

1. **Clone the repository or copy the files to your workspace.**
2. **Run Neo4j and the seeder using Docker Compose:**
   ```sh
   docker compose up -d --build
   ```
   This will start Neo4j and automatically seed it with the movie dataset using Cypher scripts.
3. **Access Neo4j Browser:**
   - Open [http://localhost:7474](http://localhost:7474) in your browser.
   - Login with the credentials specified in `.env` (default: neo4j/12345678).

## Demo Dataset

The dataset includes movies, actors, directors, and their relationships. It is seeded using the `moviesDb_cypher` file, which contains Cypher commands to create nodes and relationships.

## Example Queries: Where Graph Databases Outperform Relational Databases

### 1. Multi-hop Traversal (Friends-of-Friends)

```cypher
MATCH (p:Person {name: 'Ann'})-[:IS_FRIENDS_WITH*2]-(fof)
RETURN fof;
```

**Explanation:** Finds all people who are friends-of-friends of Ann. In a relational database, this would require multiple JOINs and complex queries. In Neo4j, it's a single, efficient query.

### 2. Shortest Path Search

```cypher
MATCH (a:Person {name: 'Ann'}), (b:Person {name: 'Dan'}),
  p = shortestPath((a)-[*]-(b))
RETURN p;
```

**Explanation:** Finds the shortest connection between Ann and Dan, regardless of relationship type. Relational databases struggle with recursive pathfinding, but Neo4j does this natively.

### 3. Flexible Relationship Queries

```cypher
MATCH (p:Person {name: 'Keanu Reeves'})-[*]-(m:Movie)
RETURN m;
```

**Explanation:** Returns all movies connected to Keanu Reeves by any relationship. In SQL, you would need to know all possible relationship tables and join them. In Neo4j, you can traverse any relationship type easily.

### 4. Pattern Matching (Actors in Movies by a Director)

```cypher
MATCH (director:Person {name: 'Ron Howard'})-[:DIRECTED]->(movie)<-[:ACTED_IN]-(actor)
RETURN actor, movie;
```

**Explanation:** Finds all actors who acted in movies directed by Ron Howard. This pattern query is simple and fast in Neo4j, but would require several JOINs in SQL.

## Why These Queries Are Hard in Relational Databases

- **JOIN Complexity:** SQL queries with many JOINs become slow and hard to write as relationships grow.
- **Recursive Traversal:** SQL is not designed for recursive queries (e.g., friends-of-friends, shortest path).
- **Schema Rigidity:** Adding new relationship types in SQL requires new tables and foreign keys. Neo4j is schema-flexible.
- **Performance:** Graph traversal in Neo4j is optimized and scales with the number of relationships, not the number of rows.

## For Students

- Try running the example queries in the Neo4j Browser.
- Modify the Cypher scripts to add new nodes and relationships.
- Compare how you would write these queries in SQL and discuss the differences.

## Resources

- [Neo4j Documentation](https://neo4j.com/docs/)
- [Cypher Query Language](https://neo4j.com/developer/cypher/)
- [Neo4j Browser Guide](https://neo4j.com/developer/neo4j-browser/)
