# frozen_string_literal: true

require 'sinatra'
require 'webrick'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'erb'
require_relative './memo'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def determine_not_found(memo_data)
    halt 404 if memo_data.nil?
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
  memo_data = Memo.find(id: params[:id])
  determine_not_found(memo_data)
  @id = memo_data[:id]
  @title = memo_data[:title]
  @contents = memo_data[:contents]
  erb :edit
end

patch '/memos/:id' do
  Memo.new.update(id: params[:id], title: params[:title], contents: params[:contents])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  Memo.new.delete(id: params[:id], title: params[:title], contents: params[:contents])
  redirect '/memos'
end

get '/memos/:id' do
  memo_data = Memo.find(id: params[:id])
  determine_not_found(memo_data)
  @id = memo_data[:id]
  @title = memo_data[:title]
  @contents = memo_data[:contents]
  erb :show
end

not_found do
  erb :not_found
end
