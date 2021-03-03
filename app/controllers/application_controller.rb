class ApplicationController < ActionController::Base

    def encode_token(payload)
        JWT.encode(payload, "secret")
    end

    def decoded_token
        if request.headers["Authorization"]
            token = request.headers["Authorization"].split(" ")[1]
            begin
                JWT.decode(token, "secret", true, algorithm: 'HS256')
            rescue
                JWT::DecodeError
                nil
            end 
        end
    end

    def logged_in_user
        if decoded_token
            user_id = decoded_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
    end

    def authorized
        render json: { message: 'Please Log In' }, status: :unauthorized unless (!!logged_in_user)
    end
end
