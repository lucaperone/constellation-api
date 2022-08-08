class RecommendationController < ApplicationController
    def user
        @user = User.find(params[:id])
        recommendations_number = 50
        scorers = [
            ContentBasedScorer.new(@user), # Explicit feedback content-based
            UserUserScorer.new(@user), # User-User collaborative
            ItemItemScorer.new(@user), # Item-Item collaborative
        ]
        
        items_score = {}
        Item.all.each do |item|
            scores = 0.0
            weights = 0.0
            scorers.each do |scorer|
                score, weight = scorer.score(item)
                scores += score * weight
                weights += weight
            end

            items_score[item.id] = weights == 0 ? 0 : (scores / weights)
        end

        @items = Item.find(items_score.sort_by{|id, score| score}.reverse!.map{|id_score| id_score[0]}.take(recommendations_number))
    end
end
