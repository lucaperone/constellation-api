class FeedbackController < ApplicationController
    LEARNING_RATE = 0.2
    def update
        @edge = UserItemEdge.between(feedback_params[:user], feedback_params[:item])
        old_score = nil
        if @edge.nil?
            unless @edge = UserItemEdge.create(feedback_params)
                render json: @edge.errors, status: :unprocessable_entity
            end
        else
            old_score = @edge.score
            @edge.update(feedback_params)
        end

        old_score ||= 0.5
        score = @edge.score

        
        if old_score != score
            new_features = @edge.user.features
            new_features.each do |key, value|
                # Kinda Perceptron Delta rule
                new_features[key] = (value 
                    + (@edge.item.features[key] - value).clamp(0,1) # Only take tags present on item into account
                    * LEARNING_RATE 
                    * (score - old_score)).clamp(0,1)
            end
            if @edge.user.update(features: new_features)
                render status: :ok
            else
                render json: @edge.user.errors, status: :unprocessable_entity

            end
        else
            render status: :ok
        end
    end

    private 

    def feedback_params
        params.require(:feedback).require(:user)
        params.require(:feedback).require(:item)
        feedback_params = params.require(:feedback).permit(:user, :item, :rating, :is_in_favourites, :visits)
        feedback_params[:user] = User.find(feedback_params[:user])
        feedback_params[:item] = Item.find(feedback_params[:item])
        return feedback_params
    end
end
