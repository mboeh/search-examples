require 'json'
require 'pp'

CORPUS = JSON.parse File.read "corpus.json"

class SearchIndex

  def initialize(documents = [])
    @corpus = []
    ingest documents
  end

  def ingest(documents)
    documents.each do |input|
      @corpus << process_document(input)
    end
  end

  def query(term)
    @corpus.select do |document|
      query_matches?(term, document)
    end.map do |document|
      deprocess_document(document)
    end
  end

  private

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

  def query_matches?(term, doc)
    doc[:text].include?(term)
  end

end

index = SearchIndex.new(CORPUS)
pp index.query("Shelley")
