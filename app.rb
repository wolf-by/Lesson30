#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"

set :database, {adapter: "sqlite3", database: "barbershop.db"}

class Client < ActiveRecord::Base
	validates :name, presence: true, length: {minimum: 3}
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :color, presence: true
end		

class Barber < ActiveRecord::Base
end

class Contact <ActiveRecord::Base
end

before do
	@barbers = Barber.all

end

get '/' do
	erb :index
end

get '/visit' do
	@c = Client.new
	erb :visit
end

post '/visit' do 
	
	@c = Client.new params[:client]
	if @c.save
 		erb "<h3>Спасибо, вы записались!</h3>"	
 	else
 		@error = @c.errors.full_messages.first
 		erb :visit
 	end
end
get '/contacts' do 
	erb :contacts
end

post '/contacts' do
	@email = params[:email]
	@message = params[:message]

	
	hh2 = { :email => 'Введите email',
			:message => 'Введите сообщение'
	}

	hh2.each do |key, value|
		if params[key] == ''
			@error = hh2[key]
			return erb :contacts
		end	
	end	
	
	Contact.create :email => @email, :message => @message

	f = File.open './public/contacts.txt', 'a'
	f.write "Email клиент: #{@email}, Сообщение: #{@message}\n"
	f.close



	erb "Данные отправлены" 
end

get '/barber/:id' do
	erb :barber
end 