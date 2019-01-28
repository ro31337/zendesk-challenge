require 'pry'
require './matchers'

# Search engine, search over props in O(N)
module SearchEngine
  def search(arr, term, value)
    arr.filter do |model|
      (model.props[term] || NilMatcher).eq?(value)
    end
  end
end
