# app.rb
require 'yaml'

require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"


before do
  @data = Psych.load_file('users.yaml')

end

get '/' do

  erb :home
end


get '/:user' do
  @name = params[:user]
  erb :user
end

helpers do
  def see_names
    @data.map do |name, content|
      "<h2><a href='#{name}'>#{name}</a></h2>"
    end.join
  end

  def info(name)
    @data[name.to_sym]
  end


  def other_users(name)
    @data.keys.select{|n| n != name}
  end

  def count_interests
    @data.values.map {|value| value[:interests].size}.reduce(:+)
  end
end

