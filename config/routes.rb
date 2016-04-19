Rails.application.routes.draw do
  namespace :api do
    get 'media/:category/index' => 'media#index'
  end

  get '/' => 'api/media#start'
end
