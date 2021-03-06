class Matcher
  attr_reader :value

  def initialize(value)
    @value = value
  end
end

class StringMatcher < Matcher
  def eq?(expected)
    @value.to_s == expected.to_s
  end
end

class ArrayMatcher < Matcher
  def eq?(expected)
    @value.include?(expected)
  end
end

# Null object patter for matcher
class NilMatcher
  def self.eq?(_expected)
    false
  end
end
