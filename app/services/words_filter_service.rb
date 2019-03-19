class WordsFilterService
  def initialize(words, filters = {})
    @words = words
    @category = filters.fetch(:category)
    @q = filters.fetch(:q)
    @part_of_speech = filters.fetch(:part_of_speech)
  end

  def filter
    if @category.present?
      category_options = @category.split(/\s*,\s*/)
      @words = @words.joins(:categories).references(:categories)
                     .where(categories: { name: category_options }).distinct
    end
    @words = @words.where('words.name LIKE ?', @q + '%') if @q.present?

    if @part_of_speech.present?
      part_of_speech_options = @part_of_speech.split(/\s*,\s*/)
      @words = @words.where(words: { part_of_speech: part_of_speech_options })
    end

    @words
  end
end
