# frozen_string_literal: true

require 'sinatra'
require 'webrick'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'
require_relative './memo'
include ERB::Util

helpers do
  def convert_json
    JSON.parse(read_memo, symbolize_names: true)
  end

  def read_memo
    File.read('db/memo.json')
  end

  def dump_memo(memos)
    File.open('db/memo.json', 'w') { |file| JSON.dump(memos, file) }
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memo_data = Memo.all
  erb :top
end

post '/memos' do
  Memo.create(title: params[:title], contents: params[:contents])
  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id/edit' do
  memo_data = convert_json.find { |file| file[:id] == params[:id] }
  halt 404 if memo_data.nil?
  @id = memo_data[:id]
  @title = memo_data[:title]
  @contents = memo_data[:contents]
  erb :edit
end

patch '/memos/:id' do
  memos = convert_json.each do |memo|
    if memo[:id] == params[:id]
      memo[:title] = params[:title]
      memo[:contents] = params[:contents]
    end
  end
  dump_memo(memos)
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memos =  convert_json.delete_if { |memo| memo[:id] == params[:id] }
  dump_memo(memos)
  redirect '/memos'
end

get '/memos/:id' do
  memo_data = convert_json.find { |file| file[:id] == params[:id] }
  halt 404 if memo_data.nil?
  @id = memo_data[:id]
  @title = h(memo_data[:title])
  @contents = h(memo_data[:contents])
  erb :show
end

not_found do
  erb :not_found
end
