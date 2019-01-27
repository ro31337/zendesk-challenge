require './matchers'
require 'json'

class Root
  attr_accessor :props

  def initialize
    @props = {}
  end

  def self.load
    instance = new
    load_entity(instance, :users, User)
    load_entity(instance, :organizations, Organization)
    load_entity(instance, :tickets, Ticket)
    instance
  end

  def self.load_entity(instance, entity, klass)
    json = File.read("#{entity}.json")
    data = JSON.parse(json).map { |props| klass.new(props) }
    props = {}
    props[entity] = data
    instance.props.merge!(props)
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

root = Root.load
