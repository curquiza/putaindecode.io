require 'csv'
# require 'byebug'

ROOT = Dir.pwd
MEILI = "#{ROOT}/meili"

articles_csv = "#{MEILI}/articles.csv"
File.delete(articles_csv) if File.exist?(articles_csv)

CSV.open(articles_csv, 'wb') do |csv|
  csv << ['id', 'title', 'author', 'date', 'slug', 'content']

  index = 0
  Dir.glob("#{ROOT}/articles/*.md") do |article|


    puts "#{index} - #{article}"
    content_array = File.readlines(article)

    raise 'HeaderError' if content_array[0] != "---\n"

    header_end = 0
    doc = {
      date: nil,
      title: nil,
      author: nil,
      slug: nil
    }

    content_array[1..-1].each_with_index do |line, i|
      header_end = i + 1
      break if line == "---\n"
      doc[:date]   ||= line[/\s*date:\s*([^>]*)\n$/, 1]
      doc[:title]  ||= line[/\s*title:\s*([^>]*)\n$/, 1]
      doc[:author] ||= line[/\s*author:\s*([^>]*)\n$/, 1]
      doc[:slug]   ||= line[/\s*slug:\s*([^>]*)\n$/, 1]
    end

    if doc[:title][0] == '"'
      doc[:title] = doc[:title][1..-2]
    end

    csv << [
      index,
      doc[:title],
      doc[:author],
      doc[:date],
      doc[:slug],
      content_array[header_end..-1].join('')
    ]

    puts 'done'
    puts '------'
    index += 1

  end # end of loop on articles folder


end # end of CSV creation
