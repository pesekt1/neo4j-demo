/* Demo web site: https://neo4j.com/developer/demos/fraud-demo/ */
/*show me the suspicious identifier and all customers connected to it */
MATCH
  (c1:Customer)-[:USES_PHONE|USES_EMAIL|RESIDES_AT]->
  (item:PhoneNumber|Email|Address)<-[:USES_PHONE|USES_EMAIL|RESIDES_AT]-
  (c2:Customer)

WHERE elementId(c1) < elementId(c2)

WITH item, count(*) AS sharedConnections
ORDER BY sharedConnections DESC
LIMIT 10

/* transaction details for a specific account */
MATCH (c:Customer)-[r:USES_PHONE|USES_EMAIL|RESIDES_AT]->(item)

RETURN item, r, c:MATCH (a:Account {accountNumber: "6083928692"})
OPTIONAL MATCH (a)-[r:SENT]->(t:Transaction)-[r2:RECEIVED]->(recipient)
RETURN a, r, t, r2, recipient;

/* extended transaction details for a specific account */
MATCH (a:Account {accountNumber: "6083928692"})

OPTIONAL MATCH (a)-[sent:SENT]->(out:Transaction)-[received:RECEIVED]->(recipient)

OPTIONAL MATCH (sender)-[incoming:SENT]->(in:Transaction)-[receivedBy:RECEIVED]->(a)

RETURN a,
       sent, out, received, recipient,
       incoming, in, receivedBy, sender;