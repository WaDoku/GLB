require 'spec_helper'

# I'm a public user No ability to create
# I'm an editor
# I'm an admin
# I create an Entry for myself
# I create an Entry for other person


describe EntriesController, :type => :controller do

  before :each do
    @user = FactoryGirl.create(:editor)
    @admin = FactoryGirl.create(:admin)
    @entry = FactoryGirl.create(:entry)
  end

  describe "GET index" do
    it "assigns all entries as @entries" do
      sign_in @admin
      get :index
      assigns(:entries).should eq([@entry])
      sign_out @admin
    end
  end

  describe "GET show" do
    it "assigns the requested entry as @entry" do
      sign_in @admin
      get :show, {:id => @entry.to_param}
      assigns(:entry).should eq(@entry)
      sign_out @admin
    end
  end

  describe "GET new" do
    it "assigns a new entry as @entry" do
      sign_in @admin
      get :new
      assigns(:entry).should be_a_new(Entry)
      sign_out @admin
    end
  end

  describe "GET edit" do
    it "assigns the requested entry as @entry" do
      sign_in @user
      @entry.user = @user
      @entry.reload
      get :edit, {:id => @entry.to_param}
      assigns(:entry).should eq(@entry)
      sign_out @user
    end
  end

  describe "POST create" do
    before :each do
      sign_in @admin
    end

    describe "Admin creates an entry" do
      it "creates a new Entry for herself" do
        expect {
          post :create, :entry => FactoryGirl.attributes_for(:entry)
        }.to change(Entry, :count).by(1)

        assigns(:entry).tap do |entry|
          expect(entry.user).to eq(@admin)
        end
      end

      it "redirects to the created entry" do
        post :create, :entry => FactoryGirl.attributes_for(:entry)
        response.should redirect_to(Entry.last)
      end
    end

    describe "Editor creates an entry" do
    end

    describe "User tries to creates an entry" do
    end










  end

  describe "PUT update" do
    describe "with valid params" do
      pending
      it "updates the requested entry" do
        entry = Entry.create! valid_attributes
        # Assuming there are no other entries in the database, this
        # specifies that the Entry created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Entry.any_instance.should_receive(:update_attributes).with({ "verfasser" => "MyString" })
        put :update, {:id => entry.to_param, :entry => { "verfasser" => "MyString" }}
      end

      it "assigns the requested entry as @entry" do
        entry = Entry.create! valid_attributes
        put :update, {:id => entry.to_param, :entry => valid_attributes}
        assigns(:entry).should eq(entry)
      end

      it "redirects to the entry" do
        entry = Entry.create! valid_attributes
        put :update, {:id => entry.to_param, :entry => valid_attributes}
        response.should redirect_to(entry)
      end
    end

    describe "with invalid params" do
      it "assigns the entry as @entry" do
        sign_in @admin
        # Trigger the behavior that occurs when invalid params are submitted
        Entry.any_instance.stub(:save).and_return(false)
        put :update, {:id => @entry.to_param, :entry => { "namenskuerzel" => "invalid value" }}
        assigns(:entry).should eq(@entry)
        sign_out @admin
      end

      it "re-renders the 'edit' template" do
        sign_in @admin
        # Trigger the behavior that occurs when invalid params are submitted
        Entry.any_instance.stub(:save).and_return(false)
        put :update, {:id => @entry.to_param, :entry => { "namenskuerzel" => "invalid value" }}
        response.should render_template("edit")
        sign_out @admin
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested entry" do
      sign_in @admin
      expect {
        delete :destroy, {:id => @entry.to_param}
      }.to change(Entry, :count).by(-1)
      sign_out @admin
    end

    it "redirects to the entries list" do
      sign_in @admin
      delete :destroy, {:id => @entry.to_param}
      response.should redirect_to(entries_url)
      sign_out @admin
    end
  end

end
