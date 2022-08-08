Rails.application.routes.draw do
    get "/recommendation/:id", to: "recommendation#user"
    post "/feedback", to: 'feedback#update'
end
