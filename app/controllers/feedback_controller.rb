class FeedbackController < ApplicationController
    LEARNING_RATE = 0.3
    def update
        # Create edge if it doesn't exist and get score
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

        # If the score changed, update User's features (preference for each feature)
        if old_score != score && !score.nil?
            new_features = @edge.user.features
            delta = score - old_score
            new_features.each do |key, value|
                # User's feature is shifted by the difference between its features
                # and the item's features, scaled by the learning rate and the change
                # in the user's score for this item
                #
                # The if ensures that only features present on the item (feature=1)
                # contributes to the shift
                if @edge.item.features[key] == 1
                    new_features[key] = (
                        value + 
                        ((delta > 0 ? 1 : 0) - value) * 
                        LEARNING_RATE * 
                        delta.abs
                    )
                end
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
