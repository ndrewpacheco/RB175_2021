require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @contents = File.readlines('data/toc.txt')
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end


get "/chapters/:number" do
  @number = params[:number]
  @title = "Chapter #{@number}"
  @contents = File.readlines('data/toc.txt')
  @chapter = File.read("data/chp#{@number}.txt")

  erb :chapter
end

get "/show/:name" do
  params[:name]
end


