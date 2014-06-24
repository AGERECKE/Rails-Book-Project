module PagesHelper
def highlight_url(url)
  url.format do |word|
    "<span class='highlight'>#{word}</span>"
  end
 end
end
