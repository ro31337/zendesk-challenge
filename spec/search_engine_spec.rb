require './search_engine'
require './models'

class Foo
  include SearchEngine
end

describe SearchEngine do
  subject { Foo.new }

  it 'should search' do
    setup = [
      Model.new(id: 1, name: 'foo'),
      Model.new(id: 2, name: 'bar'),
      Model.new(id: 3, name: 'baz'),
      Model.new(id: 4, name: 'qux')
    ]

    results = subject.search(setup, :id, 3)
    expect(results.size).to eq(1)
    expect(results[0].props[:name].value).to eq('baz')
  end

  it 'should search multiple' do
    setup = [
      Model.new(id: 1, name: 'foo'),
      Model.new(id: 2, name: 'bar'),
      Model.new(id: 3, name: 'baz'),
      Model.new(id: 4, name: 'baz')
    ]

    results = subject.search(setup, :name, 'baz')
    expect(results.size).to eq(2)
    expect(results[0].props[:name].value).to eq('baz')
    expect(results[1].props[:name].value).to eq('baz')
  end
end
