require 'sinatra'
require 'sinatra/activerecord'
require 'digest/md5'


get '/' do
	erb :index
end

post '/' do
	current = ShortenedUrl.create(url: params[:long_url])
	short_url = ShortenedUrl.encode(current.id)
	erb :new, locals: {short_url: short_url}
end

get '/:shortened' do
	id = ShortenedUrl.decode(params[:shortened])
	entry = ShortenedUrl.find(id)
	redirect entry.url
end

get '/login' do
	erb :login
end

post '/login' do
	#signup
	if User.exists?(username: params[:new_username])
		@message = "That username is already in use. Try another!"
		redirect '/login'
	else
		encoded_password = Digest::MD5.hexidigest(params[:new_password])
		current_user = User.create(username: params[:new_username], password_hash: encoded_password)
		@message = "Welcome to Teeny Tiny URL, #{current_user.username}!"
		#CHANGE AUTHENTICATION STATUS
		redirect '/'
	end

	#login
	if User.exists?(username: params[:username])
		current_user = User.find(params[:username])
		encoded_password = Digest::MD5.hexidigest(params[:password])
		if current_user.password_hash == encoded_password
			#Authenticate!?
			redirect '/'
		else
			@message = "That password doesn't match the username."
		end
	else
		@message = "That username doesn't exist yet."
	end
end


# helpers do
# 	def authenticate

# 	end

# end
