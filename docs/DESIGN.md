What useful information can we come up with?
--------------------------------------------

There are 102 heroes, and each hero has 101 matchup statistics against other heroes.
The list of heroes is
    https://github.com/sunapi386/dotabuff-ripper/blob/master/heros.txt
and the kind of data scrapped for each hero is
    https://github.com/sunapi386/dotabuff-ripper/blob/master/lina.txt

### A quick detour into DotA
In all games there are two teams, each can pick 5 heroes. Certain modes of the game allows "banning" of heroes. In captain's mode you ban 5 heroes; in captain's draft, 2; in random draft there is no banning, both teams pick from a pool of 20 heroes.
The goal is to ban the heroes that counters your picks. Let our team was called red and blue.
Captain's mode goes like this:

    blue ban => red ban => blue ban => red ban;
    blue pick => red pick => red pick => blue pick;
    blue ban => red ban => blue ban => red ban
    red pick => blue pick => red pick => blue pick;
    red ban => blue ban; red pick => blue pick.

More information on http://dota2.gamepedia.com/Game_modes

### Using graphs
I think there's a bit of graph theory that can be used, as to what to do with this data. Let each hero be a vertex. An edge in G1 be weight :advantage, and in G2 :winrate. With graphs G1 and G2 we can infer something about:
- what are the worst enemies for your current setup
- who you need the most to synergize and balance

#### Neo4j graph database
Neo4j is a graph based db, its query http://docs.neo4j.org/refcard/2.0/ should make db more useful for analysis than traditional table-based dbs. I have Neo4j 2.0.0-M06 community edition for Unix, from http://www.neo4j.org/. Just install and run, and you can use the `grapher.rb` script to populate it with data.
Originally, I've generated a query for constructing my dataset, and it was 10,405 lines long. I tried to paste it as a Cypher query, I waited 2 hours and nothing happened. It wasn't until I looked at the console.log did I discover that it silently stack-overflowed while parsing the query!
I read up about creating queries individually, and managed to make my edges between the vertices. Take a look at the `png` files in example folder.

Q: Why even use a DB? 10k edges fits easily in memory of your interpreter. You can even dump it to a YAML file for storage.

A: Well, I intend on making this a website; thinking a db would be better. Matchup and winrate are updated everyday, I was planning to scrape it nightly. And neo4j is a graph based db, so with simple queries I can have it run things like minflow, shortest path, etc

Q: Why a graph based db?

A: Scraping and adding to db was easy, the real design work is figuring out an algorithm to:
- select counter hero to as many enemy heroes as possible
- fulfill the team roles (1 carry, a semi carry or two, some supports, an initiator, etc.)
- have it bias picks on heroes with certain strategies in mind like pushing, turtling, AOE Teamfight..
I figure the graph db best represents the data I am using.
Queries such as `MATCH (hero_x)-[:counters]->(hero_y) RETURN hero_y` saves you a lot of work from implementing
graph based selection algorithms. Plus, fun little introduction to graph dbs, as they are kinda different.

