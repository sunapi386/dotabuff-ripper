dotabuff-ripper
===============

A tool for ripping off dotabuff's data. 
It can go through all the heroes, and for each hero grab all the statistics from dotabuff.
We can scrape the website for matchups data, no problem. 

## What useful information can we come up with? 
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
Neo4j is a graph based db, its query http://docs.neo4j.org/refcard/2.0/ should make db more useful for analysis than traditional table-based dbs. I've generated a query for constructing my dataset, but it is 10,405 lines long. I tried to paste it as a Cypher command (what the db query language is called) - and waited 2 hours. It still didn't finish "executing"... upon checking the /data/log/console.log file, I found that it can't parse it because it stackoverflows. Turns out that SemanticCheck.scala couldn't parse it -- so the execution failed silently, like 1 minute into execution. Now my problem lies into getting the information scrapped to that database. Initially I was using the ruby driver for neo4j, a gem called 'neography'. But it seems this gem has problems adding relationships between nodes. It has a command, `@neo.create_relationship(type, from, to, properties)`, to create relationships. This would fail. I may be using the wrong parameters to it though. Here are the parameters. 
`type => String` such as `relation`, where `relation = "advantage: #{opponent[:advantage]}, winrate: #{opponent[:winrate]}, matches: #{opponent[:matches]}"`.
I'd grab the `from` and `to` nodes by this helper: 
	def retrieve_node(name)
		@log.debug "Retrieve #{name}"
		find_query = "MATCH (x:Hero) WHERE x.name = \"#{hero}\" RETURN x;"
		@neo.execute_query find_query
	end

And this would return a Hash. Example:
```ruby
irb(main):028:0> naxe = neo.execute_query find_query
=> {"columns"=>["x"], "data"=>[[{"extensions"=>{}, "labels"=>"http://localhost:7474/db/data/node/12888/labels", "outgoing_relationships"=>"http://localhost:7474/db/data/node/12888/relationships/out", "traverse"=>"http://localhost:7474/db/data/node/12888/traverse/{returnType}", "all_typed_relationships"=>"http://localhost:7474/db/data/node/12888/relationships/all/{-list|&|types}", "self"=>"http://localhost:7474/db/data/node/12888", "property"=>"http://localhost:7474/db/data/node/12888/properties/{key}", "properties"=>"http://localhost:7474/db/data/node/12888/properties", "outgoing_typed_relationships"=>"http://localhost:7474/db/data/node/12888/relationships/out/{-list|&|types}", "incoming_relationships"=>"http://localhost:7474/db/data/node/12888/relationships/in", "create_relationship"=>"http://localhost:7474/db/data/node/12888/relationships", "paged_traverse"=>"http://localhost:7474/db/data/node/12888/paged/traverse/{returnType}{?pageSize,leaseTime}", "all_relationships"=>"http://localhost:7474/db/data/node/12888/relationships/all", "incoming_typed_relationships"=>"http://localhost:7474/db/data/node/12888/relationships/in/{-list|&|types}", "data"=>{"name"=>"axe"}}]]}
irb(main):029:0> naxe.class
=> Hash
```

I'm kind of stuck at this point.