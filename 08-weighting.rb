#!/usr/bin/env ruby -I.

require 'pp'
require 'ranked_search_index'
require 'corpus'

module AuthorFavoringSearch
  extend self
  
  STOP_WORDS = %w[a an the by and or of to on]

  def process_document(raw)
    { words: [ [ 5, tokenize(raw["title"])  ] ,
               [ 10 , tokenize(raw["author"]) ] ,
             ]                                         ,
      data: raw                   ,
    }
  end

  def deprocess_document(doc)
    doc[:data]
  end

  def parse_query(query)
    tokenize(query)
  end

  def rank_match(terms, doc)
    doc[:words].reduce(0) do |total, (weight, words)|
      total + (words & terms).length * weight
    end
  end

  def tokenize(phrase)
    phrase.downcase.split - STOP_WORDS
  end

end

index = RankedSearchIndex.new(strategy: AuthorFavoringSearch, documents: CORPUS)
pp index.query("james")
