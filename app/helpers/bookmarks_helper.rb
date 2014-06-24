module BookmarksHelper
  def user_can_administrate_bookmark?(bookmark)
    user_signed_in? && bookmark.user.id == current_user.id
  end
  
end
