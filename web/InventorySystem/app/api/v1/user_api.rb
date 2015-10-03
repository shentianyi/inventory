module V1
  class UserApi < Grape::API
    namespace :user do
      format :json
      
      desc 'login'
      params do
        requires :name, type: String
      end
      post :login do
        user = User.auth(params[:name])
        if user
          {result: 1, content: "successful"}
        else
          {result: 0, content: "failure"}
        end
      end
    end
  end
end