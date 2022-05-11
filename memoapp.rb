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

  def determine_not_found
    halt 404 if @memo.nil?
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = Memo.all
  erb :top
end

post '/memos' do
  Memo.create(title: params[:title], content: params[:content])
  redirect '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id/edit' do
  @memo = Memo.find(id: params[:id])
  determine_not_found
  erb :edit
end

patch '/memos/:id' do
  Memo.update(id: params[:id], title: params[:title], content: params[:content])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  Memo.delete(id: params[:id])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = Memo.find(id: params[:id])
  determine_not_found
  erb :show
end

not_found do
  erb :not_found
end
