require './models'

describe Model do
  subject { Model.new(id: 1, name: 'foo') }

  it 'should have props with matchers' do
    expect(subject.props).to be
    expect(subject.props[:id]).to respond_to(:eq?)
    expect(subject.props[:name]).to respond_to(:eq?)
  end

  it 'should respond to as_text' do
    expected = <<-EXPECTED.strip_heredoc
      id              => 1
      name            => foo
    EXPECTED

    expect(subject.as_text).to eq(expected)
  end
end
