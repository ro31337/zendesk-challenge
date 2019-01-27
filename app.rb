require './models'
require 'readline'
require './location'

model = Root.new
location = Location.get(model.props)
location = location.next
location = location.next
