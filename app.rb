require './models'
require 'readline'

root = Root.new
LIST = root.props.keys.sort

comp = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }
Readline.completion_proc = comp

while line = Readline.readline('> ', true).strip!
  p line
end