class BookmarkObserver < Mongoid::Observer
  def after_save(bookmark)
    Sunspot.index!(bookmark.link.reload)
  end
end
