class RankedSearchIndex

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
    @corpus.map    {|doc|     [doc, @strategy.rank_match(query, doc)] }
           .sort_by{|_, rank| -rank }
           .select {|_, rank| rank > 0 }
           .map    {|doc, _|  @strategy.deprocess_document(doc) }
  end

end
