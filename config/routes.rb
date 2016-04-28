Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api do
    get 'media/:category/index' => 'media#index'
  end

  get '/' => 'api/media#start'
end
