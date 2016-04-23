#!/usr/bin/env ruby -I.

require 'pp'
require 'search_index'
require 'corpus'

class StemmedSearch
  
  STOP_WORDS = %w[a an the by and or of to on]

  # A real stemmer adds dependencies, but this illustrates the case
  DEPLURALIZE = ->(word) do
    word.sub(/s$/, '')
  end

  def initialize(stemmer:)
    @stemmer = stemmer
  end

  def process_document(raw)
    { words: tokenize([raw["title"], raw["author"]].join(" ")),
      data: raw                   ,
    }
  end

  def deprocess_document(doc)
    doc[:data]
  end

  def parse_query(query)
    tokenize query 
  end

  def query_matches?(terms, doc)
    (doc[:words] & terms).any?
  end

  def tokenize(phrase)
    phrase.downcase.split.map(&@stemmer) - STOP_WORDS
  end

end

search = StemmedSearch.new(stemmer: StemmedSearch::DEPLURALIZE)
index = SearchIndex.new(strategy: search, documents: CORPUS)
pp index.query("war world")
