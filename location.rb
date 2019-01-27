require './search_engine'

# Factory method for menu locations
module Location
  def self.get(props)
    if props.is_a?(Array)
      ArrayLocation.new(props)
    elsif props.is_a?(Hash)
      HashLocation.new(props)
    else
      raise "Unsupported location type #{props.class}"
    end
  end
end

# Menu location abstract class
class MenuLocation
  attr_reader :props

  def initialize(props)
    @props = props
  end

  def select_from_menu(menu)
    loop do
      choice = Readline.readline('> ', true)
      choice.strip!
      exit if %w[exit quit].include?(choice)
      return choice if menu.include?(choice)
      puts "ERROR: Incorrect choice \"#{choice}\""
    end
  end

  def init_autocomplete(menu)
    Readline.completion_proc = proc { |s| menu.grep(/^#{Regexp.escape(s)}/) }
  end
end

# Hash menu location, allows to select one of the hash keys
class HashLocation < MenuLocation
  def next
    menu = props.keys.sort
    usage(menu)
    choice = select_from_menu(menu)
    Location.get(props[choice])
  end

  def usage(menu)
    puts
    puts 'Select one of the following tables (press Tab for autocomplete):'
    puts '-' * 3
    puts menu
    init_autocomplete(menu)
  end
end

# Array location, performs O(N) search over model entries
class ArrayLocation < MenuLocation
  include SearchEngine

  def next
    menu = props.first.props.keys

    term = get_search_term(menu)
    value = get_search_value(menu)
    search(term, value)
    self
  end

  private

  def get_search_term(menu)
    puts 'Enter search term (press Tab for autocomplete):'
    init_autocomplete(menu)
    select_from_menu(menu)
  end

  def get_search_value(menu)
    puts 'Enter search value:'
    print '> '
    gets.chomp.strip
  end
end