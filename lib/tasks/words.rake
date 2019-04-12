# Get words list here: https://netix.dl.sourceforge.net/project/arabic-wordlist/Arabic-Wordlist-1.6.zip
# PATH_TO_LIST should be a relative path from the root of the repo.
PATH_TO_LIST = './lib/tasks/arabic-wordlist-1.6.txt'.freeze

namespace :words do
  desc 'populates words table with arabic words'
  task populate: :environment do
    words = File.readlines(PATH_TO_LIST)
    Word.import [:name], words.map { |word| [word.chomp] },
                validate: false,
                on_duplicate_key_ignore: true,
                batch_size: 1e5
    puts 'Words created'
    puts "Word count: #{Word.count}"
  end
end
