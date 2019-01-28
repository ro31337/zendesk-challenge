require './matchers'

describe StringMatcher do
  it 'should match strings' do
    expect(StringMatcher.new('foo').eq?('foo')).to be true
    expect(StringMatcher.new('foo').eq?('bar')).to be false
  end

  it 'should match strings and integers' do
    expect(StringMatcher.new('123').eq?(123)).to be true
    expect(StringMatcher.new('123').eq?(321)).to be false
  end

  it 'should handle nils' do
    expect(StringMatcher.new('foo').eq?(nil)).to be false
  end
end

describe StringMatcher do
  subject do
    ArrayMatcher.new(
      %w[foo bar]
    )
  end

  it 'should match if expected is present' do
    expect(subject.eq?('foo')).to be true
    expect(subject.eq?('bar')).to be true
    expect(subject.eq?('baz')).to be false
  end

  it 'should handle nils and empty values' do
    expect(subject.eq?(nil)).to be false
    expect(subject.eq?('')).to be false
  end
end
