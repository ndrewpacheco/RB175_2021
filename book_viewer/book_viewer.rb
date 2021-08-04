require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines('data/toc.txt')
end

helpers do
  def in_paragraphs(str)
    str.split("\n\n").map.with_index do |paragraph, index|
      "<p id='paragraph#{index}'>" + paragraph + "</p>"
    end.join
  end

  def strong_wrap(str, query)
    str.gsub(query, "<strong>#{query}</strong>")
  end
end

def each_chapter
  chapters = {}
  @contents.map.with_index do |title, idx|
    idx += 1;
    contents = File.read("data/chp#{idx}.txt")
    yield idx, title, contents
  end
end

def matching_chapters(query)
  results = []
  return results if params[:query].nil?

  each_chapter do |number, title, contents|
    if contents.include?(query)
      matches = {}
      contents.split("\n\n").each_with_index do |paragraph, idx|
        matches[idx] = paragraph if paragraph.include?(query)
      end
      p matches.class
      results << {number: number, title: title, paragraphs: matches}
    end
  end
  results
end


get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end


get "/chapters/:number" do
  number = params[:number]

  chapter_name = @contents[number.to_i - 1]
  @title = "Chapter #{number} : #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/search" do
  @queries = matching_chapters(params[:query])
  erb :search
end

not_found do
  redirect "/"
end

