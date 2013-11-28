Installation
============

Windows Install
---------------

A bit more work than linux to make a vanilla windows install "sane" (to have gcc, make, etc).
Lots of gems are broken in ruby x64 bit. I strongly recommend to install x32 bit version of ruby 2.0.0p247
and its compatible Devkit. If you do not need to allocate more than 2GB of RAM in your Ruby processes
then you don't need 64bit Ruby. Heed ths advice or be prepared to go through lots of hell compiling Nokogiri.

### 1. Download & Install Binaries
1. [Install ruby 2.0.0-p247](http://rubyinstaller.org/downloads/)
2. [Install neo4j](http://www.neo4j.org/download/windows)
3. Install [git and cygwin](https://code.google.com/p/msysgit/downloads/detail?name=Git-1.8.4-preview20130916.exe&can=2&q=)
select "Run Git and included Unix tools from the Windows Command Prompt" option.
4. Optional but recommended if developing [install rubymine](https://www.jetbrains.com/ruby/download/)

### 2. Configure Environment
1. Clone the [dotabuff-ripper repo](https://github.com/sunapi386/dotabuff-ripper)
2. Seed the neo4j db: unzip the included neo4j database into `C:\Users\<username>\Documents\Neo4j\` and startup
Neo4j Community and set database location to the seed (you should rename graph.db folder -> default.graphdb unless you want to
set the custom path every time you start the neo4j db)
3. [Unzip the Ruby 2.0 development kit](http://rubyinstaller.org/downloads/) into your C:\ and run `ruby dk.rb init` and
 `ruby dk.rb install`
4. Open `cmd` and `gem install bundler`
5. Go to `dotabuff-ripper` folder and `bundle install`
6. Checkout the prompt `cd src ; ruby prompt.rb`

Linux Install
-------------

1. Requires Ruby 2.0.0 and Neo4j database.
2. `gem install bundler`
3. `bundle install`
4. Seed the db by extracting graph.db.zip into the neo4j data folder
5. Visit `localhost:7474` for graphical db interface
6. `ruby test/prompt.rb`
