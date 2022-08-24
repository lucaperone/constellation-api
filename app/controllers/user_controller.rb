class UserController < ApplicationController
    before_action :set_user
    
    def friends
        render json: @user.friends
    end
    
    def favourites
        render json: @user.favourites
    end

    private

    def set_user
        @user = User.find(params[:id])
    end
end
