class User5s::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication, only: [:new, :create]

   def new
     super
     if current_user5.email == "admin"
       @user = User5.new
     end
   end

   def create
     if current_user5.email == "admin"
       @user = User5.new(user_params)
       if @user.save
         redirect_to root_path
       else
         render :new
       end
     end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :rep1, :rep2, :rep3)
  end
end
