class ApplicationController < ActionController::Base

    def encode_token(payload)
        JWT.encode(payload, "secret")
    end

    def decode_token
        if request.header["Authorization"]
            token = request.header["Authorization"].split(" ")[1]
            begin
                JWT.decode(token, "secret", true, algorithm: 'HS256')
            rescue
                JWT::DecodeError
                nil
            end 
        end
    end

    def logged_in_user
        if decode_token
            user_id = decode_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
    end

    def authorized
        render json: { message: 'Please Log In' }, status: :unauthorized unless (!!logged_in_user)
    end
end
