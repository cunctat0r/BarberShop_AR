#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
	validates :name, presence: true
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :color, presence: true	
end

class Barber < ActiveRecord::Base
end

class Contact < ActiveRecord::Base
end

before do
	@barbers = Barber.order "created_at DESC"
	@contacts = Contact.order "created_at DESC"
end

get '/' do
	
	erb :index
end

get '/visit' do
  erb :visit
end

post '/visit' do
  
  loaded = params[:client]
  client = Client.new loaded
  client.save

  erb "Отлично, #{loaded[:name]}, мастер #{loaded[:barber]} будет Вас ждать в #{loaded[:datestamp]}"

end

get '/showusers' do
  @results = Client.order "created_at DESC"
  erb :showusers
end

get '/contacts' do  
  erb :contacts
end

post '/contacts' do
  err_hash = {:author => 'Представьтесь, пожалуйста',
              :message => 'Напишите что-нибудь'
          }

  loaded = params[:contact]

  err_hash.each do |key, value|
    if loaded[key] == ''
      @error = err_hash[key]      
      return erb :contacts
    end
  end

  contact = Contact.new loaded
  contact.save

  #erb "Ваше сообщение очень важно для нас, #{@author}!"
  redirect to "/contacts"

end

get '/about' do
  erb "Наша парикмахерская -- самая парикмахерская в мире!"
end