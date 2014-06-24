require 'spec_helper'

describe BookmarksController, :type => :controller  do
  include Devise::TestHelpers
  render_views
  before(:each) do
   @request.env["devise.mapping"] = Devise.mappings[:user]
     @user = FactoryGirl.create(:user)
    # visit "/login"

     #fill_in "user_login",    :with => "leander-taler"
     #fill_in "user_password", :with => "secret1234"

     #click_button "Sign in"
      #                   pp response.status
sign_in :user, @user
 
    @bookmark = double(Bookmark)
    @bookmark.stub(:user=)
    @bookmark.stub(:save).and_return(true)
    Bookmark.stub(:new).and_return(@bookmark)
  # get :new, :user_id => @user.id
 # pp Bookmark
  end
 
  describe "GET new" do
     context "given the user is not signed in" do
       it "is not accessible" do
         sign_out  @user     
         get :new, user_id: @user.id
         response.should_not be_success
       end
     end 
     context "given the user is signed in" do
       it "should have a current_user" do
           # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
           subject.current_user.should_not be_nil
         end
       it "is accessible" do
        # get :new, user_id: @user.id
        visit new_user_bookmark_path(:user_id => @user.id)
     #    pp response.body.inspect
    #     pp response.status.inspect
         response.should be_success
       end
     end
   end

   describe "POST create" do 
     context "given the user is not signed in" do
       it "is not accessible" do
         sign_out @user
         post :create, user_id: @user.id
         response.should_not be_success
       end
     end

     context "given the user is signed in" do
       it "is accessible" do
         post :create, user_id: @user.id
         response.should be_redirect
       end
     end
   end
 
  
  describe "GET new" do
    context "given the user is signed in" do
      it "initializes a new Bookmark model" do
     Bookmark.should_receive(:new)
     visit new_user_bookmark_path(:user_id => @user.id)
   #   pp response.body.inspect
    #  pp response.status.inspect
     # pp body.inspect
    end
    
      it "renders the new template" do
      visit new_user_bookmark_path(:user_id => @user.id)
        response.should render_template(:new)
      end
    end
  end
  
  describe "POST create" do
    context "given the user is signed in" do
      it "initializes a new Bookmark model" do
        Bookmark.should_receive(:new).and_return(@bookmark)
        post :create, user_id: @user.id
      end
      
      context "given the record is saved successfully" do
        it "redirects to the user's profile" do
         post :create, user_id: @user.id
          response.should redirect_to(user_path(@user.id))
        end
      end
      
      context "given the record is not saved successfully" do
        it "renders the new template" do
       @bookmark.stub(:save).and_return(false)
         post :create, user_id: @user.id
         pp response.body.inspect
           pp response.status.inspect
           pp body.inspect
         response.should render_template("new")
        end
      end
    end
  end
end