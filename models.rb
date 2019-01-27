require './matchers'
require 'json'

class Root
  attr_accessor :props

  def initialize
    @props = {}
    load
  end

  private

  def load
    load_entity(User)
    load_entity(Organization)
    load_entity(Ticket)
  end

  def load_entity(klass)
    entity = klass.to_s.downcase + 's'
    json = File.read("#{entity}.json")
    data = JSON.parse(json).map { |props| klass.new(props) }
    props = {}
    props[entity] = data
    @props.merge!(props)
  end
end

class Model
  attr_accessor :props

  def initialize(props)
    @props = props.update(props) do |_, v|
      if v.is_a?(Array)
        ArrayMatcher.new(v)
      else
        StringMatcher.new(v)
      end
    end
  end
end

class User < Model
end

class Organization < Model
end

class Ticket < Model
end
