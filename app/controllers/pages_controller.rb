class PagesController < ApplicationController
  def index
    @bookmarks = Bookmark.order_by("created_at desc").page(params[:page]).per(5)
  end
  
  def search 
    if params[:search].present? && params[:search][:q].present?
      @query = params[:search][:q]
      @search = Sunspot.search(Link) do
        fulltext(params[:search][:q]) do
          highlight :url
        end
        facet :domain, :minimun_count => 1
        with :domain, params[:search][:domain]
            if params[:search][:domain].present?
        paginate(:page => params[:page], :per_page => 10)
      end
    end
    else
      redirect_to root_url
    end
  end
end
