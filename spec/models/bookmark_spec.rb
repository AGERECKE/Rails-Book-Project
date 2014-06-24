require 'spec_helper'

describe Bookmark do

  
  before(:each) do
    @bookmark = Bookmark.new(:url => "http://www.heise.de", :title => "Heise Online Webseite")
  end
  
  describe "validations" do 
    context "given a valid bookmark" do 
      it "has a title that has a length within 10 and 255 characters" do
        @bookmark.title = "Rails-Expertenwissen"
        @bookmark.should have(:no).errors_on(:title)
      end
      
      it "has an url that has a length of maximum 2083 characters" do
        @bookmark.url = "http://rails-exptertenwissen.de"
        @bookmark.should have(:no).errors_on(:url)
      end
      
      it "has notes that have a length of maximum 1024 characters" do
        
        @bookmark.notes = "Die Webseite zum Buch Ruby on Rails 3.1 Expertenwissen"
        @bookmark.should have(:no).errors_on(:notes)
      end
    end
  end
      

      
      describe "validations" do 
        context "given an invalid bookmark" do 
          it "has no title" do
            @bookmark.title = ""
            @bookmark.should have(2).errors_on(:title)
          end

          it "has a title that has a length less then 10 characters" do
            #Der Titel hat 9 Zeichen
            @bookmark.title = "a"*9
            @bookmark.should have(1).error_on(:title)
          end

          it "has a title that has a length more than 255 characters" do
            # Der Titel hat 256 Zeichen
            @bookmark.title = "a"*256
            @bookmark.should have(1).error_on(:title)
          end

          it "has no url" do
            @bookmark.url = ""
            @bookmark.should have(1).error_on(:url)
          end

          it "has an url that has a length more than 2083 characters" do
            # Die URL hat 2084 Zeichen
            @bookmark.url = "a"*2084
            @bookmark.should have(2).errors_on(:url)
          end

          it "has an url that does not begin with http or https" do
            @bookmark.url = "rails-expertenwissen.de"
            @bookmark.should have(1).error_on(:url)
          end

          it "has notes that have a length more than 1024 characters" do
            # Die Notes haben 1025 Zeichen
            @bookmark.notes = "a"*1025
            @bookmark.should have(1).error_on(:notes)
          end
      
    end
  end
  describe "#save" do
    it "calls #assign_tags" do
      @bookmark.should_receive(:assign_tags)
      @bookmark.save
    end
  end
  
  describe "#assign_tags" do
    it "creates the tags if they do not exists yet" do
      @bookmark.tag_list = "Ruby, Rails"
      Tag.should_receive(:find_or_create_by).twice.and_return(Tag.new)
      @bookmark.__send__(:assign_tags)
    end
  end
  
  describe "#tag_list" do
    context "given the tag_list attribute is present" do
      it "returns the tag_list attribute" do
        @bookmark.tag_list = "Ruby, Rails"
        @bookmark.tag_list.should eql(@bookmark.instance_variable_get("@tag_list"))
    end
  end
    
    context "given the tag_list attribute is not present" do
      it "returns the names of the associated tags using #map" do
        @bookmark.tags = [Tag.new]
        @bookmark.tags.should_receive(:map).and_return([Tag.new])
        @bookmark.tag_list
      end
    end
  end
  
  describe "#set_link" do
    it "finds or creates a link model using the url" do
      url = @bookmark.instance_variable_get("@url")
      Link.should_receive(:find_or_create_by).with(:url => url)
      @bookmark.__send__(:set_link) 
  end
end
  
  describe "#url" do
    context "given the associated link is present" do
      before(:each) do
        link = Link.new(:url => "http://rubyonrails.org")
        @bookmark.link = link
      end
      
      
      context "given the url attribute is not present" do
        it "returns the url attribute" do
          @bookmark.url = "http://rails-expertenwissen.de"
          @bookmark.url.should eql(@bookmark.instance_variable_get("@url"))
      end
    end
      
      context "given the url attribute is not present" do
        it "returns the link's url attribute" do
          @bookmark.url = nil
          @bookmark.url.should eql(@bookmark.link.url)
        end
      end
    end
    
    context "given the associated link is not present" do
      it "returns the url attribute" do
        @bookmark.link = nil
        @bookmark.url = "http://rails-expertenwissen.de"
        @bookmark.url.should eql(@bookmark.instance_variable_get("@url"))
      end
    end
  end
end

