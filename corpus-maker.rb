#!/usr/bin/env ruby -rjson

INFILE  = "corpus.txt"
OUTFILE = "corpus.json"

docs = File.read(INFILE)
           .split("\n")
           .map{|l| 
             m = /(?<title>.+) by (?<author>.+) \(\d+\)/.match(l) and
               {title: m[:title], author: m[:author]}
           }
           .compact

File.write(OUTFILE, JSON.dump(docs))

puts "YOU GOT IT DUDE"
