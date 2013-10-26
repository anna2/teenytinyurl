get '/' do
	erb :index
end

post '/' do
	if session[:user_id].nil?
		@current = ShortenedUrl.create(url: params[:long_url])
	else
		user = User.find(session[:user_id])
		@current = user.shortened_urls.create(url: params[:long_url])
	end
	@short_url = ShortenedUrl.encode(@current.id)
	erb :new
end

delete '/:id' do
	ShortenedUrl.destroy(params[:id])
	redirect '/'
end

get '/login' do
	erb :login
end

post '/login' do
	#signup
	if User.exists?(username: params[:new_username])
		@sign_up_message = "That username is already in use. Try another!"
	elsif params[:new_username].nil?
		@sign_up_message = "Create a password for your acount."
	else
		encoded_password = User.encode(params[:new_password])
		current_user = User.create(username: params[:new_username], password_hash: encoded_password)
		session[:user_id] = current_user.id
		puts session[:user_id]
		redirect '/'
	end

	#login
	if User.exists?(username: params[:username])
		current_user = User.find_by(username: params[:username])
		if User.encode(params[:password]) == current_user.password_hash
			session[:user_id] = current_user.id
			puts session[:user_id]
			redirect '/'
		else
			@log_in_message = "That password doesn't match the username."
		end
	else
		@log_in_message = "That username isn't in our records."
	end
	erb :login
end

get '/logout' do
	session[:user_id] = nil
	redirect '/'
end

get '/:shortened' do
	id = ShortenedUrl.decode(params[:shortened])
	entry = ShortenedUrl.find(id)
	redirect entry.url
end
