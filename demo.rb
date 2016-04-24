#!/usr/bin/env ruby -I.

require 'sinatra'
require 'search_index_plus'

Dir["*-*.rb"].each do |file|
  require file
end

module DummySearch
  extend self

  def process_document(raw)
    raw
  end

  def deprocess_document(doc)
    doc
  end

  def parse_query(query)
  end

  def query_matches?(term, doc)
    true
  end
end

STRATEGIES = [
  DummySearch,
  SubstringSearch,
  CasefoldingSubstringSearch,
  WordSearch,
  AllWordSearch,
  AnyWordSearch,
  AnyWordSearchWithStopwords,
  RankedWordSearch,
  AuthorFavoringSearch,
  StemmedSearch
]

get "/" do
  @strategies = STRATEGIES
  @selected_strategy_idx = (params['strategy'] || 0).to_i
  selected_strategy = @strategies[@selected_strategy_idx]
  query = params['query']
  @results = SearchIndexPlus.new(strategy: selected_strategy, documents: CORPUS).query(params['query'])

  erb <<-EOF
    <form>
      <p><input name="query" type="text" value="<%= params['query'] %>">
        &nbsp;
        <select name="strategy">
          <% @strategies.each_with_index do |strategy, idx| %>
            <option value="<%= idx %>" <% if @selected_strategy_idx == idx %>selected<% end %>><%= strategy.name %></option>
          <% end %>
        </select>
        <input type="submit">
      </p>
    </form>
    <table>
      <tr>
        <th>Title</th>
        <th>Author</th>
      </tr>
      <% @results.each do |result| %>
        <tr>
          <td><%= result['title'] %></td>
          <td><%= result['author'] %></td>
        </tr>
      <% end %>
    </table>
  EOF
end
