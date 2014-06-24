class Bookmark 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, :type => String
  field :notes, :type => String
  
  belongs_to :user
  belongs_to :link
  
  has_and_belongs_to_many :tags
  
  attr_accessor :url
  
  attr_accessible :link_id, :notes, :title, :user_id, :url, :tag_list
  
  
  
  validates :title,
            :presence => true,
            :length => { :within => 10..255 }
            
  validates :notes,
            :length => { :maximum => 1024 },
            :allow_blank => true
            
  validates :url,
            :presence => true,
            :format => {
              :with => /^(#{URI::regexp(%w(http https))})$|^$/
            },
            :length => { :maximum => 2083 }
            
            before_save :set_link
            
            def url
              if self.link.present?
                @url || self.link.url
              else
                @url
              end
            end
            
              attr_writer :tag_list
              before_save :assign_tags

              def tag_list
                @tag_list || tags.map(&:name).join(', ')
              end 
              
            private 
            
                def assign_tags
                  if @tag_list
                    self.tags = @tag_list.gsub(/\s+/,"").split(/,/).uniq.map do |name|
                      Tag.find_or_create_by(:name => name.strip)
                    end
                  end
                end
                
            def set_link
              self.link = Link.find_or_create_by(:url => @url)
            end
            
      
end
