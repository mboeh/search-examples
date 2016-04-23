#!/usr/bin/env ruby -I.

require 'pp'
require 'search_index'
require 'corpus'

module SubstringSearch
  extend self

  def process_document(raw)
    { text: [ raw["title"]   ,
              raw["author"]  ,
            ].join(" ")      ,
      data: raw              ,
    }
  end

  def deprocess_document(doc)
    doc[:data]
  end

  def parse_query(query)
    query
  end

  def query_matches?(query, doc)
    doc[:text].include?(query)
  end

end

index = SearchIndex.new(strategy: SubstringSearch, documents: CORPUS)
pp index.query("Austen")
