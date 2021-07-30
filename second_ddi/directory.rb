require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"


get "/" do
  @directory = Dir.glob("public/*").map {|file| File.basename(file) }.sort
  @directory.reverse! if params[:sort] == "desc"

  erb :home
end


# get "/file1.txt" do
#   File.read("file1.txt")
# end