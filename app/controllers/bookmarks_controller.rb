class BookmarksController < ApplicationController
before_filter :authenticate_user!
before_filter :find_bookmark, :only => [:edit, :destroy, :update]
before_filter :check_url, :only => [:create]

respond_to :html, :xml, :json
def new
  @bookmark = Bookmark.new(params[:bookmark])
end

def show
  @bookmark = Bookmark.find(params[:id])
  respond_with(@bookmark)
end

def create 
  @bookmark = Bookmark.new(params[:bookmark])
  @bookmark.user = current_user
  
  if @bookmark.save
    redirect_to user_path(current_user)
  else
   render :new
  end
end

def edit
end

def destroy
  @bookmark.destroy
  redirect_to current_user, :flash => { :notice => "Bookmark successfully deleted."}
end

def update
  if @bookmark.update_attributes(params[:bookmark])
    redirect_to user_path(current_user)
  else
    render :edit
  end
end

protected

def find_bookmark
  @bookmark = current_user.bookmarks.find(params[:id])
    if @bookmark.blank?
      redirect_to root_url, :flash =>
      {:alert => "You are not authorized to access this bookmark"}
    end
  end
  
  def check_url
    if current_user.saved_bookmark?(params[:bookmark])
      link = Link.where(:url => params[:bookmark][:url]).first
      bookmark = current_user.bookmarks.where(:link_id => link.id).first
      redirect_to edit_user_bookmark_url(:id => bookmark.id,
      :bookmark => params[:bookmark]),
      :flash => { :notice => "You already saved this URL."}
  end
end
end