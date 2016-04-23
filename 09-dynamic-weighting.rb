#!/usr/bin/env ruby -I.

require 'pp'
require 'ranked_search_index'
require 'corpus'

class WeightedSearch
  STOP_WORDS = %w[a an the by and or of to on]

  def initialize(weights:)
    @weights = weights
  end

  def process_document(raw)
    weighted_words = raw.map do |attribute, text|
      [ @weights[attribute] || 1, tokenize(text) ]
    end
    { words: weighted_words, data: raw }
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

puts "-- Weighting title --"
index = RankedSearchIndex.new(
  strategy: WeightedSearch.new(weights: { "title" => 10 }),
  documents: CORPUS
)
pp index.query("james")

puts "-- Weighting author --"
index = RankedSearchIndex.new(
  strategy: WeightedSearch.new(weights: { "author" => 10 }),
  documents: CORPUS
)
pp index.query("james")

