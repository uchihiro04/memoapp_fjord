require 'sinatra'
require 'webrick'
require 'sinatra/reloader'
require 'json'
require 'securerandom'



get "/memos" do
    @title = "メモアプリ"
    unless FileTest.exist?("db/memo.json")
      File.open("db/memo.json", "w")
    end
    @memo_data = if File.read("db/memo.json",1).nil?
      nil
    else
      JSON.parse(File.read("db/memo.json"), symbolize_names: true)
    end
    erb :top
end

post "/memos" do
  if File.read("db/memo.json",1).nil?
    memos = []
  else
    memos = JSON.parse(File.read("db/memo.json"), symbolize_names: true)
  end
  memo = {
    title: params[:title],
    contents: params[:contents],
    id: SecureRandom.uuid
  }
  memos << memo
  File.open("db/memo.json", "w") do |file|
    JSON.dump(memos, file)
  end
  redirect "/memos"
end

get "/memos/new" do
  erb :new
end

get "/memos/:id" do
  memo_data = JSON.parse(File.read("db/memo.json"), symbolize_names: true)
  @title = memo_data.find { |file| file[:id] == params[:id] }[:title]
  @contents = memo_data.find { |file| file[:id] == params[:id] }[:contents]
  erb :show
end