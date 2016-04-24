#!/usr/bin/env ruby -I.

require 'pp'
require 'search_index'
require 'corpus'

module AnyWordSearchWithStopwords
  extend self
  
  STOP_WORDS = %w[a an the by and or of to on]

  def process_document(raw)
    { words: [ raw["title"]       ,
               raw["author"]      ,
             ].join(" ")
              .downcase
              .split - STOP_WORDS ,
      data: raw                   ,
    }
  end

  def deprocess_document(doc)
    doc[:data]
  end

  def parse_query(query)
    query.downcase.split - STOP_WORDS
  end

  def query_matches?(terms, doc)
    (doc[:words] & terms).any?
  end
end

index = SearchIndex.new(strategy: AnyWordSearchWithStopwords, documents: CORPUS)
pp index.query("war of the worlds")
