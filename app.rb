require './models'
require 'readline'
require './location'

model = Root.new
location = Location.get(model.props)

loop do
  location = location.next
end
