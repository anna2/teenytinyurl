get '/' do
	@name = User.find(session[:user_id]).username unless session[:user_id].nil?
	@array = ShortenedUrl.where(user_id: session[:user_id]) unless session[:user_id].nil?
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
	begin
		ShortenedUrl.destroy(params[:id])
		redirect '/'
	rescue ActiveRecord::RecordNotFound
		redirect '/'
	end
end

get '/login' do
	erb :login
end

post '/signup' do
	begin
	  current_user = User.signup(params[:new_username], params[:new_password])
	  session[:user_id] = current_user.id
	  redirect '/'
	rescue ExistingUsername
		@sign_up_message = "'#{params[:new_username]}' is already in use. Try a different username."
		erb :login
	rescue InvalidUsername
		@sign_up_message = "Usernames must have between 2 and 30 characters."
		erb :login
	rescue InvalidNewPassword
		@sign_up_message = "Create a password for your account."
		erb :login
	end
end

post '/login' do
	begin
		current_user = User.login(params[:username], params[:password])
		session[:user_id] = current_user.id
		redirect '/'
	rescue NonexistentUsername
		@log_in_message = "'#{params[:username]}' isn't in our records."
		erb :login
	rescue NonmatchingPassword
		@log_in_message = "That password doesn't match the username '#{params[:username]}'."
		erb :login
	end
end

get '/logout' do
	session[:user_id] = nil
	redirect '/'
end

get '/:shortened' do
	entry = ShortenedUrl.get_from_hex(params[:shortened])
	redirect entry.url
end
