class UsersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'Mitarbeiter erfolgreich erstellt!'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'Mitarbeiter erfolgreich bearbeitet'
    else
      render 'edit'
    end
  end

  def destroy
    if @user.entries.any?
      @user.entries.update_all(user_id: User.default_admin.id)
      redirect_to users_url, notice: "#{@user.name} wurde erfolgreich gelöscht. Die Einträge wurden dem Administrator übertragen."
    else
      redirect_to users_url, notice: "#{@user.name} wurde erfolgreich gelöscht."
    end
    @user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
