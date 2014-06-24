class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @bookmarks = @user.bookmarks.order_by("created_at desc").page(params[:page]).per(5)
  end
end
