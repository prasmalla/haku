namespace :scraper do
desc "scrape sites"
  require 'nokogiri'
  require 'open-uri'

  task :nepali_movie => :environment do
(2..12).each do |i|
    url = "http://www.isansar.com/movies/nepali_movies/page/#{i}"
    # url = "http://www.isansar.com/movies/nepali_movies"
    doc = Nokogiri::HTML(open(url))

    doc.css(".main-content article").each do |item|
      title = item.at_css("h2").text
      image = item.at_css("img")
      if image
        image = image[:src]
      else
        image = "default"
      end

      page_url = item.at_css("a")[:href]
      content = Nokogiri::HTML(open(page_url))
      youtube = content.css('//a[@href*="youtube"]')
      youtube = content.css('//a[@href*="yt"]') if youtube.size < 1
      if youtube.size < 1
        video_url = content.css('//a[@href*="blogspot"]')
        begin
          video_content = Nokogiri::HTML(open(video_url[0][:href]))
        rescue #OpenURI::HTTPError
          next
        end
        youtube = video_content.css('//iframe[@src*="youtube"]')
        next if youtube.size < 1
        youtube = youtube[0][:src].split('/').last.split('?').first
        video = "http://www.youtube.com/watch?v=#{youtube}"
      else
        video = "http://www.youtube.com/watch?v=#{youtube[0][:href][/(?<=[?&]v=)[^&$]+/]}"
      end
      title = title.gsub!(/[^0-9a-z ]|(nepali movie)|(full)/i, '')
      begin
        Medium.create!({title: title.squish, url: video, thumbnail: image, category: 'nepalimovie'})
      rescue
        #update existing record?
      end
    end
end
    # Product.find_all_by_price(nil).each do |product|
    #   url = "http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=#{CGI.escape(product.name)}&Find.x=0&Find.y=0&Find=Find"
    #   doc = Nokogiri::HTML(open(url))
    #   price = doc.at_css(".PriceCompare .BodyS, .PriceXLBold").text[/[0-9\.]+/]
    #   product.update_attribute(:price, price)
    # end
  end

  task :nepali_news => :environment do
    url = "http://www.canadanepal.info/dailynews/"
    content = Nokogiri::HTML(open(url))
    youtube = content.at_css('//iframe[@src*="youtube"]')[:src].split('/')[-1]
    image = "http://img.youtube.com/vi/#{youtube}/default.jpg"
    video = "http://www.youtube.com/watch?v=#{youtube}"
    title = content.at_css('.st').text[2..-1].squish

    Medium.where(category: 'nepalinews').delete_all #truncate
    begin
      Medium.create!({title: title, url: video, thumbnail: image, category: 'nepalinews'})
    rescue
      #update existing record?
    end
  end

  task :nepali => :environment do
    Medium.where(category: 'nepali').delete_all #truncate
    url = "http://www.canadanepal.info/"
    doc = Nokogiri::HTML(open(url))

    doc.css("a").each_with_index do |link, i|
      next if i < 11 #skip header links
      page_url = link[:href]
      begin
        content = Nokogiri::HTML(open(page_url))
      rescue
        next #failed external link
      end
      iframe = content.at_css('//iframe[@src*="youtube"]')
      next if !iframe
      puts "#{i}-" + page_url
      youtube = iframe[:src].split('/')[-1]
      image = "http://img.youtube.com/vi/#{youtube}/default.jpg"
      video = "http://www.youtube.com/watch?v=#{youtube}"
      title = content.at_css('.post-title')
      title = !title ? 'Untitled' : title.text.gsub!(/[^0-9a-z ]/i, '')
      title = "Daily News" if i == 12
      title = "Rasifal" if i == 14
      begin
        Medium.create!({title: title.squish, url: video, thumbnail: image, category: 'nepali'})
      rescue
        #update existing record?
      end
    end
    # end
  end

  task :nepali_tv => :environment do
# (2..12).each do |i|

    url = "http://www.isansar.com/tvshows/nepalitvshow"#/page/#{i}"
    doc = Nokogiri::HTML(open(url))

    doc.css(".main-content article").each do |item|
      title = item.at_css("h2").text
      image = item.at_css("img")
      if image
        image = image[:src]
      else
        image = "default"
      end

      page_url = item.at_css("a")[:href]
      content = Nokogiri::HTML(open(page_url))
      youtube = content.css('//a[@href*="youtube"]')
      youtube = content.css('//a[@href*="yt"]') if youtube.size < 1
      if youtube.size < 1
        video_url = content.css('//a[@href*="blogspot"]')
        video_url = content.css('//a[@href*="ramsarmedia"]') if video_url.size < 1
        begin
          video_content = Nokogiri::HTML(open(video_url[0][:href]))
        rescue
          next #broken link
        end if video_url
        youtube = video_content.css('//iframe[@src*="youtube"]')
        if youtube.size < 1
          playwire = ''
          video_content.css('//div[@class*="post-body entry-content"]').css('script').each do |script|
            playwire = script['data-config'].split('/')
          end
          image = "https://cdn.video.playwire.com/#{playwire[3]}/videos/#{playwire[6]}/poster_0000.png"
          video = "https://cdn.video.playwire.com/#{playwire[3]}/videos/#{playwire[6]}/video-sd.mp4"
          # binding.pry
          #https://cdn.video.playwire.com/17179/videos/3940027/video-sd.mp4
          #https://cdn.video.playwire.com/17179/videos/3940027/poster_0000.png
        else
          youtube = youtube[0][:src].split('/').last.split('?').first
        end
        video = "http://www.youtube.com/watch?v=#{youtube}"
      else
        video = "http://www.youtube.com/watch?v=#{youtube[0][:href][/(?<=[?&]v=)[^&$]+/]}"
      end
      Medium.where(category: 'nepalitv').delete_all #truncate
      begin
        Medium.create!({title: title, url: video, thumbnail: image, category: 'nepalitv'})
      rescue
        #update existing record?
      end
    end
# end
  end
end
