class UserController < ApplicationController
    before_action :set_user, only: [:friends, :favourites]
    
    def friends
        render json: @user.friends
    end
    
    def favourites
        render json: @user.favourites.map{|favourite| {item: favourite, rating: Edge.between(@user, favourite).rating}}
    end

    def friendship
        user = friend_params[:user]
        friend = friend_params[:friend]
        edge = UsersEdge.where(user_a: user, user_b: friend).or(UsersEdge.where(user_a: friend, user_b: user)).first
        if edge.nil?
            if UsersEdge.create(user_a: user, user_b: friend, are_friends: friend_params[:are_friends])
                render status: :ok
                return
            end
        else
            edge.update(are_friends: friend_params[:are_friends])
            render status: :ok
            return
        end
        render status: :unprocessable_entity
    end

    private

    def set_user
        @user = User.find(params[:id])
    end

    def friend_params
        params.require(:friendship).require(:user)
        params.require(:friendship).require(:friend)
        params.require(:friendship).require(:are_friends)
        friend_params = params.require(:friendship).permit(:user, :friend, :are_friends)
        friend_params[:user] = User.find(friend_params[:user])
        friend_params[:friend] = User.find(friend_params[:friend])
        return friend_params
    end
end
