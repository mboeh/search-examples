#!/usr/bin/env ruby -I.

require 'pp'
require 'search_index'
require 'corpus'

module AnyWordSearch
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
    query.downcase.split
  end

  def query_matches?(terms, doc)
    (doc[:words] & terms).any?
  end
end

index = SearchIndex.new(strategy: AnyWordSearch, documents: CORPUS)
pp index.query("war of the worlds")
