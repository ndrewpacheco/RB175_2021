require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "yaml"

before do
  @users = YAML.load_file('users.yaml')
end

helpers do
  def count_interests
    @users.map do |user|
      user[1][:interests]
    end.flatten
       .size
  end
end

get '/' do
  # @interests_amount = @users.map do |user|
  #   user[1][:interests]
  # end.flatten
  #    .size

  erb :home
end

get "/:user" do
  name = params[:user].to_sym
  @user = @users[name]
  @user[:name] = params[:user]
  erb :user
end

