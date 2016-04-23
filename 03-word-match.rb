#!/usr/bin/env ruby -I.

require 'pp'
require 'search_index'
require 'corpus'

module WordSearch
  extend self

  def process_document(raw)
    { words: [ raw["title"]  ,
               raw["author"] ,
             ].join(" ")
              .downcase
              .split         ,
      data: raw              ,
    }
  end

  def deprocess_document(doc)
    doc[:data]
  end

  def parse_query(query)
    query.downcase
  end

  def query_matches?(term, doc)
    doc[:words].include?(term)
  end
end

index = SearchIndex.new(strategy: WordSearch, documents: CORPUS)
pp index.query("war")
