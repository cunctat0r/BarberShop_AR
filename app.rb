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
	validates :author, presence: true
	validates :message, presence: true
end

before do
	@barbers = Barber.order "created_at DESC"
	@contacts = Contact.order "created_at DESC"
	@client = Client.new
end

get '/' do	
	erb :index
end

get '/visit' do  
  erb :visit
end

post '/visit' do  
  loaded = params[:client]
  @client = Client.new loaded
  if @client.valid?
  	@client.save
  	erb "Отлично, #{loaded[:name]}, мастер #{loaded[:barber]} будет Вас ждать в #{loaded[:datestamp]}"
  else
  	@error = @client.errors.full_messages.first
  	erb :visit
  end
end

get '/showusers' do
  @results = Client.order "created_at DESC"
  erb :showusers
end

get '/contacts' do  
  erb :contacts
end

post '/contacts' do
  loaded = params[:contact]

  contact = Contact.new loaded
  if contact.valid?
  	contact.save
  	redirect to "/contacts"
  else
  	@error = contact.errors.full_messages.first
  	return erb :contacts
  end
  
end

get '/about' do
  erb "Наша парикмахерская -- самая парикмахерская в мире!"
end

get '/barber/:id' do

  @barber = Barber.find params[:id]

  erb :barber
end