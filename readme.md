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

### Using graphs    ?
I think there's a bit of graph theory that can be used, as to what to do with this data. Let each hero be a vertex. An edge in G1 be weight :advantage, and in G2 :winrate. With graphs G1 and G2 we can infer something about:
- what are the worst enemies for your current setup
- who you need the most to synergize and balance

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