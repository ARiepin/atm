Rails.application.routes.draw do
  mount GrapeSwaggerRails::Engine => '/docs'

  namespace :api, module: :api, defaults: { format: :json } do
    namespace :v1 do
      scope :notes do
        get :withdraw, to: 'notes#withdraw'
        post :deposit, to: 'notes#deposit'
      end
    end
  end
end
