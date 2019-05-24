require 'csv'

PATH_TO_CSV = './db/words.csv'.freeze
namespace :words do
  desc 'populates words table with arabic words'
  task populate: :environment do
    words = CSV.read(PATH_TO_CSV)
    words.each do |row|
      word_name, category_name, part_of_speech = row.map { |s| s.strip }
      Word.create!(
        name: word_name,
        categories: [Category.find_or_create_by!(
          name: category_name
        )],
        part_of_speech: part_of_speech
      )
    end
    puts 'Words created'
    puts "Word count: #{Word.count}"
    puts "Category count: #{Category.count}"
  end
end
