require 'spec_helper'

describe UsersController, :type => :controller do
  describe "test if only admins can inspect the user list" do
    it "should show user list to admin" do
      admin = FactoryGirl.create(:admin)
      sign_in admin
      get :index
      response.status.should == 200
      sign_out admin
    end
    it "should not show user list editor" do
      editor = FactoryGirl.create(:editor)
      sign_in editor
      get :index
      response.status.should == 302
      sign_out editor
    end
  end

  describe "test if only admins can read users' information and update their role" do
    before :each do
      @admin = FactoryGirl.create(:admin)
      @user = FactoryGirl.create(:editor)
    end
    it "should show user's information to admin" do
      sign_in @admin
      get :index, :id => 1
      response.status.should == 200
      sign_out @admin
    end

    it "should locate the requested user and update role for admin" do
      sign_in @admin
      put :update_role, :id => @user.id, user: FactoryGirl.attributes_for(:editor, role: "admin")
      assigns(:user).should eq(@user)
      @user.reload
      @user.role.should == "admin"
      sign_out @admin
    end

    it "should not update user's role for common user" do
      sign_in @user
      put :update_role, :id => @user.id, user: FactoryGirl.attributes_for(:editor, role: "admin")
      @user.reload
      @user.role.should_not == "admin"
      sign_out @user
    end

    it "should update other attributes of current user's profile but no role" do
      sign_in @user
      put :update, :id => @user.id, :user => {"name" => "new_name", "email" => "new@email.com", "role" => "alien"}
      @user.reload
      @user.role.should_not == "alien"
      @user.role.should == "editor"
      @user.name.should == "new_name"
      @user.email.should == "new@email.com"
      sign_out @user
    end

  end

  describe "test if current user can edit his own profile" do
    before(:each) do
      @user = FactoryGirl.create(:editor)
      sign_in @user
    end

    it "should show edit page for current user's own profile" do
      get :edit, :id => @user.id
      response.should render_template("edit")
    end

    it "should not show edit page for another user's profile" do
      other = FactoryGirl.create(:editor)
      sign_in @user
      get :edit, :id => other.id
      response.should_not render_template("edit")
      response.should redirect_to root_path
    end
  end

  describe "test if can delete a user" do
    before :each do
      @user = FactoryGirl.create(:editor)
    end
    it "should delete a user" do
      pending
      delete :destroy, :id => @user.id
      User.find(@user.id).should be_nil
      response.should redirect_to users_path
    end
  end


end
