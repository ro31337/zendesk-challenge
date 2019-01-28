require './search_engine'

module BelongsTo
  include SearchEngine

  def belongs_to(foreign_key, table, name)
    return '' unless @props[foreign_key]
    results = search(
      @root.props[table],
      '_id',
      @props[foreign_key].value
    )
    results.reduce('') do |memo, model|
      memo += hash_to_str(model.props, "*#{name}:")
    end
  end
end

module HasMany
  include SearchEngine

  def has_many(foreign_key, table, name, only = ['_id'])
    text = ''

    results = search(
      @root.props[table],
      foreign_key,
      @props['_id'].value
    )

    results.each_with_index do |model, i|
      only.each do |k|
        text += "*#{i}_#{name}:#{k.ljust(15, ' ')} => #{model.props[k].value}\n"
      end
    end

    text
  end
end
