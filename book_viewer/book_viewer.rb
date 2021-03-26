require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end


helpers do
  def in_paragraphs(content)
    counter = 0
    content.split(/\n\n/).map do |paragraph|
      counter += 1
      "<p id='paragraph#{counter}'>#{paragraph}</p>"
    end
  end
end

not_found do
  redirect "/"
end

def each_chapter
  @contents.each_with_index do |name, idx|
    number = idx + 1
    contents = File.read("data/chp#{number}.txt")
    yield name, number, contents
  end
end

def chapters_matching(query)

  results = []

  return results if !query || query.empty?

  each_chapter do |name, number, contents|
    results << {number: number, name: name} if contents.include?(query)
  end
  ## return value
  # an array of the chapters titles/links? that containt query
  results
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

## return array of pararaghs with matching query within results

def search_paragraphs(chapter_number, query)
  @chapter = File.read("data/chp#{chapter_number}.txt")
  paragraphs = in_paragraphs(@chapter)


  # each_chapter do | _, number|
  #   if chapter_number ==
  # end

  paragraphs.select! {|paragraph| paragraph.include?(query)}
  paragraphs.map do |paragraph|

    id = paragraph.match(/paragraph\d+/)

    "<li><a href='/chapters/#{chapter_number}##{id}'>#{paragraph}</a></li>"
  end.join
  # return a string of li elements, that link to the p's that match the query
end


