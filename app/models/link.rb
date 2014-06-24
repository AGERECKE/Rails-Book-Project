class Link 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunspot::Mongoid
  
  field :url, :type => String
  field :bookmarks_count, :type => Integer
  
  has_many :bookmarks
  attr_accessible :bookmarks_count, :url
  
  searchable do
    text :url, :boost => 2.0, :stored => true
    
    text :bookmark_titles do
      bookmarks.map { |bookmark| bookmark.title }
    end
    
    text :bookmark_notes do
      bookmarks.map { |bookmark| bookmark.notes }
    end
    
    text :tags do
      bookmarks.map do |bookmark|
        bookmark.tags.map { |tag| tag.name }
      end.flatten.uniq
    end
  end
  
  searchable do
    string :domain do
      URI.parse(url).host
    end
  end
  
end
