class TagsController < ApplicationController
  respond_to :json, :html
  
  def index
    @tags = Tag.where(:name => /#{params[:term]}/).limit(10)
    respond_with(@tags) do |format|
      format.json do
        render :json => @tags.map { |tag| tag.name }.to_json
      end
    end
  end
  
  def show
    @tag = Tag.where(:name => params[:id]).first
    @bookmarks = Bookmark.where(:tag_ids => @tag.id).
                  page(params[:page]).per(5)
  end
end
