Rails.application.routes.draw do
    get "/recommendation/:id", to: "recommendation#user"
end
