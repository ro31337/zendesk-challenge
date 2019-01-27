class Matcher
  attr_reader :value

  def initialize(value)
    @value = value
  end
end

class StringMatcher < Matcher
  def eq?(expected)
    @value.to_s == expected
  end
end

class ArrayMatcher < Matcher
  def eq?(expected)
    @value.include?(expected)
  end
end

