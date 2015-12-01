module V1
  class UserApi < Grape::API
    namespace :users do
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

	  desc 'download user data'
	  params do
	   optional :page,type: Integer,default:0
	   optional :per_page,type: Integer,default:1000
	  end
	  get do
		  users=User.offset(params[:page]*params[:per_page]).limit(params[:per_page])
		  {result:1,content:users}
	  end
    end
  end
end

