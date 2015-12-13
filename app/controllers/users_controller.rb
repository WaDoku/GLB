class UsersController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    if admin?
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    else
      flash[:notice] = 'Access denied!'
      redirect_to root_path
    end

  end

  def entries
    @page = params[:page] || 0
    params[:search] = nil if params[:search] and params[:search].strip == ""
    all_entries = (params[:search] ? current_user.search_entries(params[:search]) : current_user.entries).order("romaji_order")
    @count = all_entries.count
    @entries = all_entries.page(@page)
    respond_to do |format|
      format.html # users_entries.html.erb
      format.json { render json: @entries }
    end
  end


  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    if admin?
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    else
      flash[:notice] = 'Access denied!'
      redirect_to  root_path
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    if current_user.id == params[:id].to_i
      @user = User.find(params[:id])
      respond_to do |format|
        format.html # edit.html.erb
      end
    else
      flash[:notice] = 'Access denied!'
      redirect_to root_path
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Mitarbeiter erfolgreich erstellt!' }
        format.json { render json: @user, role: :created, location: @user }
      else
        format.html { redirect_to new_user_path, notice: @user.errors.messages.values.flatten.uniq.join("<br/>") }
        format.json { render json: @user.errors, role: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(user_params)
    if params[:user]["role"] && !admin?
      params[:user].delete("role")
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to root_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_user_path(@user), notice: 'Something went wrong.' }
        format.json { render json: @user.errors, role: :unprocessable_entity }
      end
    end
  end

  def update_role
    @user = User.find(params[:id])
    respond_to do |format|
      if admin?
        if @user.update_attributes(user_params)
          format.html { redirect_to users_path, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { redirect_to user_path(@user), notice: 'Something went wrong.' }
          format.json { render json: @user.errors, role: :unprocessable_entity }
        end
      else
        format.html { redirect_to root_path, notice: 'Access denied!' }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User #{@user.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end
  private
    def user_params
      params.require(:user).permit(:name, :role, :password_confirmation, :password, :email)
    end
end
