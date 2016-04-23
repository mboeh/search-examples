class SearchIndex

  def initialize(strategy:, documents: [])
    @strategy = strategy
    @corpus = []
    ingest documents
  end

  def ingest(documents)
    documents.each do |input|
      @corpus << @strategy.process_document(input)
    end
  end

  def query(expression)
    query = @strategy.parse_query(expression)
    @corpus.select do |document|
      @strategy.query_matches?(query, document)
    end.map do |document|
      @strategy.deprocess_document(document)
    end
  end

end
