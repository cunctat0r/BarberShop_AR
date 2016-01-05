#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
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
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @barber = params[:barber]
  @color = params[:color]

  err_hash = {:username => 'Введите имя',
              :phone => 'Введите телефон',
              :datetime => 'Введите дату и время',
              :color => 'Выберите цвет'}

  err_hash.each do |key, value|
    if params[key] == ''
      @error = err_hash[key]      
      return erb :visit
    end
  end

  c = Client.new params[:client]
  c.save

  erb "Отлично, #{@username}, мастер #{@barber} будет Вас ждать в #{@datetime}"

end

get '/showusers' do
  #db = get_db
  #db.results_as_hash = true

  @results = Client.order "created_at DESC"

  erb :showusers
end

get '/contacts' do  
  erb :contacts
end

post '/contacts' do
  @author = params[:author]
  @message = params[:message]

  err_hash = {:author => 'Представьтесь, пожалуйста',
              :message => 'Напишите что-нибудь'
          }

  err_hash.each do |key, value|
    if params[key] == ''
      @error = err_hash[key]      
      return erb :contacts
    end
  end

  contact = Contact.new 
  contact.author = @author
  contact.message = @message
  contact.save

  #erb "Ваше сообщение очень важно для нас, #{@author}!"
  redirect to "/contacts"

end

get '/about' do
  erb "Наша парикмахерская -- самая парикмахерская в мире!"
end