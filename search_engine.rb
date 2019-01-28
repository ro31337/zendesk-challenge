require 'pry'
require './matchers'

# Search engine, search over props in O(N)
module SearchEngine
  def search(term, value)
    # Filter out results by calling matcher
    results = props.filter do |model|
      (model.props[term] || NilMatcher).eq?(value)
    end
    print_results(results)
  end

  # Show results here, can be improved later
  def print_results(results)
    if results.empty?
      puts '(not found)'
      return
    end

    puts "#{results.size} record(s) found:"

    results.each do |result|
      puts '=' * 40
      puts result.to_s
    end
  end
end
