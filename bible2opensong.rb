require 'rubygems'  
require 'nokogiri'  
require 'open-uri'  

books = {"Genesis" => 1, "Exodus" => 2, "Leviticus" => 3, "Numbers" => 4, "Deuteronomy" => 5, "Joshua" => 6, "Judges" => 7, "Ruth" => 8, "1 Samuel" => 9, "2 Samuel" => 10, "1 Kings" => 11, "2 Kings" => 12, "1 Chronicles" => 13, "2 Chronicles" => 14, "Ezra" => 15, "Nehemiah" => 16, "Esther" => 19, "Job" => 22, "Psalm" => 23, "Proverbs" => 24, "Ecclesiastes" => 25, "Song of Solomon" => 26, "Isaiah" => 29, "Jeremiah" => 30, "Lamentations" => 31, "Baruch" => 32, "Ezekiel" => 33, "Daniel" => 34, "Hosea" => 35, "Joel" => 36, "Amos" => 37, "Obadiah" => 38, "Jonah" => 39, "Micah" => 40, "Nahum" => 41, "Habakkuk" => 42, "Zephaniah" => 43, "Haggai" => 44, "Zechariah" => 45, "Malachi" => 46, "Matthew" => 47, "Mark" => 48, "Luke" => 49, "John" => 50, "Acts" => 51, "Romans" => 52, "1 Corinthians" => 53, "2 Corinthians" => 54, "Galatians" => 55, "Ephesians" => 56, "Philippians" => 57, "Colossians" => 58, "1 Thessalonians" => 59, "2 Thessalonians" => 60, "1 Timothy" => 61, "2 Timothy" => 62, "Titus" => 63, "Philemon" => 64, "Hebrews" => 65, "James" => 66, "1 Peter" => 67, "2 Peter" => 68, "1 John" => 69, "2 John" => 70, "3 John" => 71, "Jude" => 72, "Revelation" => 73}

one_chapter_books = ["Philemon"]

book = nil
book_name = nil
if ARGV[0].nil?
  puts "You must enter a book to convert"
  exit
else
  book_name = ARGV[0]
  book = books[ARGV[0]]
  if book.nil?
    puts "Unrecognised book"
	exit
  end
end

file = File.open("#{book_name}.opensong.txt", "w")
file.puts "<b n=\"#{book_name}\">"
chapter_content = true
chapter = 0
while chapter_content
  chapter +=1
  url = "http://www.biblegateway.com/passage/?book_id=#{book}&chapter=#{chapter}&version=CEV"
  doc = Nokogiri::HTML(open(url))
  break if doc.content =~ /not found for version/ || (one_chapter_books.include?(book_name) && chapter > 1)
  puts chapter
  file.puts "<c n=\"#{chapter}\">"
  verse_num = 0  
  doc.css(".versenum").each do |verse|
    verse_num +=1
    file.puts "<v n=\"#{verse_num}\">#{verse.next.text.sub(/\s+$/,"")}</v>"
  end
  file.puts "</c>"
end
file.puts "</b>"
file.close
