class UserBlock::UsersController < ApplicationController
	skip_before_action :authenticate_user
	def sign_up
		user = UserBlock::User.new(user_params)
		if user.save
			token = JwtToken.encode_token(user.id)
			render json: { data: UserBlock::UserSerializer.new(user).serializable_hash, token: token, message:'User created successfully' },status: 200
		else
			render json: { errors: user.errors.full_messages,message:"User not created" }, status: 422
		end
	end

	def sign_in 
		user = UserBlock::User.find_by(email: params[:email])
		if user
			if user.authenticate(params[:password])
				token = JwtToken.encode_token(user.id)
				render json: {data: UserBlock::UserSerializer.new(user), token: token, message: 'Loggin successfully...' }, status: 200
			else
				render json: {errors: "Invalid password" },status:401
			end
		else
			render json: {errors: "User email does not register" }, status: 404
		end
	end

		def index
	  	end

	  	def login_with_github
	  		user = UserBlock::User.from_omniauth(request.env["omniauth.auth"])
	  		if user
	  			token = JwtToken.encode_token(user.id)
				render json: {data: UserBlock::UserSerializer.new(user), token: token, message: 'Loggin successfully...' }, status: 200
			else
				render json: { message: 'User not found' }, status: 200
	  		end
	  	end

	private

	def user_params
		params.require(:user).permit(:name, :email, :location, :password)
	end
end