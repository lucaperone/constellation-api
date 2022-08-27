Rails.application.routes.draw do
    get "/recommendation/:id", to: "recommendation#user"

    get "/recommendation/:id/lists", to: "recommendation#lists"

    get "/recommendation/:id/friends", to: "recommendation#friends"
    
    get "/graph/:id", to: "recommendation#graph"

    get "/favourites/:id", to: "user#favourites"
    get "/friends/:id", to: "user#friends"
    
    post "/friendship", to: "user#friendship"
    post "/feedback", to: "feedback#update"
end
