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
          {result: 1, content: user}
        else
          {result: 0, content: "验证失败，请重试"}
        end
      end
    end
  end
end

