class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Mitarbeiter erfolgreich erstellt!' }
        format.json { render json: @user, role: :created, location: @user }
      else
        format.html { render 'new' } 
        format.json { render json: @user.errors, role: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'Mitarbeiter erfolgreich bearbeitet' }
        format.json { head :no_content }
      else
        format.html { render 'edit' } 
        format.json { render json: @user.errors, role: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user.entries.any?
        @user.entries.update_all(user_id: User.default_admin.id)
        format.html { redirect_to users_url, notice: "#{@user.name} wurde erfolgreich gelöscht. Die Einträge wurden dem Administrator übertragen." }
      else
        format.html { redirect_to users_url, notice: "#{@user.name} wurde erfolgreich gelöscht." }
      end
      @user.destroy
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
