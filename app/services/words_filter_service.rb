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
      categories = Category.where(name: category_options)
      # Get ids of all categories and their descendant categories
      category_ids = []
      categories.each do |category|
        category_ids.push(*category.descendant_ids)
        category_ids.push(category.id)
      end
      @words = @words.joins(:categories).references(:categories)
                     .where(categories: { id: category_ids }).distinct
    end
    @words = @words.where('words.name LIKE ?', @q + '%') if @q.present?

    if @part_of_speech.present?
      part_of_speech_options = @part_of_speech.split(/\s*,\s*/)
      @words = @words.where(words: { part_of_speech: part_of_speech_options })
    end

    @words
  end
end
