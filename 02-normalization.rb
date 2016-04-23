#!/usr/bin/env ruby -I.

require 'pp'
require 'search_index'
require 'corpus'

module CasefoldingSubstringSearch
  extend self

  def process_document(raw)
    { text: [ raw["title"]   ,
              raw["author"]  ,
            ].join(" ")
             .downcase       ,
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
    doc[:text].include?(term)
  end
end

index = SearchIndex.new(strategy: CasefoldingSubstringSearch, documents: CORPUS)
# pp index.query("austen")
pp index.query("war")
