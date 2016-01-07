#!/usr/bin/env ruby

require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'
require 'json'

years = [2014, 2015]

urls = {}

years.each do |year|
baseurl = "https://developer.apple.com/videos/wwdc/#{year}/"
puts "scraping #{baseurl}"
doc = Nokogiri::HTML(open(baseurl, :allow_redirections => :all))

doc.search("li.collection-item//a").each do |link|

	title = link.content
	href = link.attr("href")

  slug = href.split("/")[-1]
	print "getting video URL for #{slug}..."
  sessionurl = baseurl + href

  page = Nokogiri::HTML(open(sessionurl))

	videolink = page.search("video.center//source").first
	videosource = videolink.attr("src")

	videodata = {
		"videoURL" => videosource
	}

	# for videos earlier than 2015 no thumbnails seem to be available :(
	if year == 2015
		sessionnumber = videosource.split("/")[-2]
		thumbnailcomponents = videosource.split("/")
		thumbnailcomponents.pop
		thumbnailcomponents.push("images")
		thumbnailcomponents.push("#{sessionnumber}_734x413.jpg")
		thumbnailurl = thumbnailcomponents.join("/")
		videodata["thumbnailURL"] = thumbnailurl
	end

  urls[slug] = videodata
  puts " done."
end

end
File.open("videoURLs.json", 'w') do |f|
  f.write(urls.to_json)
end
