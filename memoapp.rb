require 'sinatra'
require 'webrick'
require 'sinatra/reloader'

get "/memos" do
  erb :top
end

