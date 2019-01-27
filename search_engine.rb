# Search engine, search over props in O(N)
module SearchEngine
  def search(term, value)
    # Filter out results by calling matcher
    results = props.filter do |model|
      model.props[term].eq?(value)
    end

    # Show results here, can be improved later
    results.each do |result|
      puts '=' * 40
      puts result.to_s
    end
  end
end
