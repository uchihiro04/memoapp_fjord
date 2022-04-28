require 'sinatra'
require 'webrick'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'
include ERB::Util

helpers do
  def convert_json
    JSON.parse(read_memo, symbolize_names: true)
  end

  def read_memo
    File.read("db/memo.json")
  end

  def dump_memo(memos)
    File.open("db/memo.json", "w") { |file| JSON.dump(memos, file) }
  end
end

get "/" do
  redirect "/memos"
end

get "/memos" do
    File.open("db/memo.json", "w") unless FileTest.exist?("db/memo.json")
    @memo_data = File.read("db/memo.json",1).nil? ? nil : convert_json
    erb :top
end

post "/memos" do
  memos = File.read("db/memo.json",1).nil? ? [] : convert_json
  memo = {
    title: params[:title],
    contents: params[:contents],
    id: SecureRandom.uuid
  }
  memos << memo
  dump_memo(memos)
  redirect "/memos"
end

get "/memos/new" do
  erb :new
end

get "/memos/:id/edit" do
  memo_data = convert_json.find { |file| file[:id] == params[:id] }
  @id = memo_data[:id]
  @title = memo_data[:title]
  @contents = memo_data[:contents]
  erb :edit
end

patch "/memos/:id" do
  memos =  convert_json.each do |memo|
    if memo[:id] == params[:id]
      memo[:title] = params[:title]
      memo[:contents] = params[:contents]
    end
  end
  dump_memo(memos)
  redirect "/memos/#{params[:id]}"
end

delete "/memos/:id" do
  memos =  convert_json.delete_if { |memo| memo[:id] == params[:id] }
  dump_memo(memos)
  redirect "/memos"
end

get "/memos/:id" do
  memo_data = convert_json.find { |file| file[:id] == params[:id] }
  @id = memo_data[:id]
  @title = h(memo_data[:title])
  @contents = h(memo_data[:contents])
  erb :show
end