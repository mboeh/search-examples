
class SearchIndexPlus

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
    @corpus.map    {|doc|     [doc, rank_match(query, doc)] }
           .sort_by{|_, rank| -rank }
           .select {|_, rank| rank > 0 }
           .map    {|doc, _|  @strategy.deprocess_document(doc) }
  end

  private

  def rank_match(query, doc)
    if @strategy.respond_to?(:rank_match)
      @strategy.rank_match(query, doc)
    else
      @strategy.query_matches?(query, doc) ? 1 : 0
    end
  end

end
