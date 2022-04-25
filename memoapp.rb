require 'sinatra'
require 'webrick'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

get "/memos" do
    @title = "メモアプリ"
    File.open("db/memo.json", "w") unless FileTest.exist?("db/memo.json")
    @memo_data = File.read("db/memo.json",1).nil? ? nil : JSON.parse(File.read("db/memo.json"), symbolize_names: true)
    erb :top
end

post "/memos" do
  File.read("db/memo.json",1).nil? ? memos = [] : memos = JSON.parse(File.read("db/memo.json"), symbolize_names: true)
  memo = {
    title: params[:title],
    contents: params[:contents],
    id: SecureRandom.uuid
  }
  memos << memo
  File.open("db/memo.json", "w") { |file| JSON.dump(memos, file) }
  redirect "/memos"
end

get "/memos/new" do
  erb :new
end

get "/memos/:id" do
  memo_data = JSON.parse(File.read("db/memo.json"), symbolize_names: true).find { |file| file[:id] == params[:id] }
  @title = memo_data[:title]
  @contents = memo_data[:contents]
  erb :show
end

# SinataraアプリのGitについて調べる