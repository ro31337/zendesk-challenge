require './matchers'
require './relationships'
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
    data = JSON.parse(json).map { |props| klass.new(props, self) }
    props = {}
    props[entity] = data
    @props.merge!(props)
  end
end

class Model
  attr_accessor :props, :root

  def initialize(props, root)
    @root = root
    @props = props.update(props) do |_, v|
      if v.is_a?(Array)
        ArrayMatcher.new(v)
      else
        StringMatcher.new(v)
      end
    end
  end

  def as_text
    hash_to_str(props)
  end

  private

  def hash_to_str(hash, prefix = '')
    hash.reduce('') do |memo, (k, matcher)|
      memo += "#{prefix}#{k.ljust(15, ' ')} => #{matcher.value}\n"
    end
  end
end

class User < Model
  include BelongsTo
  include HasMany

  def as_text
    super + \
      has_many('submitter_id', 'tickets', 'ticket (submitter)', %w[_id subject]) + \
      has_many('assignee_id', 'tickets', 'ticket (assignee)', %w[_id subject]) + \
      belongs_to('organization_id', 'organizations', 'organization')
  end
end

class Organization < Model
end

class Ticket < Model
  include BelongsTo

  def as_text
    super + \
      belongs_to('organization_id', 'organizations', 'organization') + \
      belongs_to('submitter_id', 'users', 'submitter') + \
      belongs_to('assignee_id', 'users', 'assignee')
  end
end
