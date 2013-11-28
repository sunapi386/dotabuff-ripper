dotabuff-ripper
===============

A collection of tools to improve your dota hero counterpicking decisions.

| File             | Content  |
|    -------------:|:-----|
| scraper.rb       | A tool for ripping off dotabuff's data, can through all the heroes, and for each hero grab all the statistics from dotabuff. |
| db/database.rb   | Connector to a neo4j database. |
| db/creator.rb    | Modules to build a neo4j database from the scrapped info. |
| db/questioner.rb | Module to query the db for matchup info, and the like. |
| prompt.rb        | A prompt menu, once you have everything setup. |
| test.rb          | Example to show how I test some functions. |

Usage
-----
Run the menu prompt `$ ~/workspace/dotabuff-ripper/src$ ruby prompt.rb`


- - - - 
|**References**|
|--------------|
|[Installation](docs/INSTALLATION.md)|
|[Design](docs/DESIGN.md)|
|[License](docs/LICENSE.md)|
|[Issues](https://github.com/sunapi386/dotabuff-ripper/issues)|
|[Pull request](https://github.com/sunapi386/dotabuff-ripper/pulls)|