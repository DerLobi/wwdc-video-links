#!/usr/bin/env ruby

require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'
require 'json'

years = [2014, 2015]

urls = {}

years.each do |year|
baseurl = "https://developer.apple.com/videos/wwdc/#{year}/"

doc = Nokogiri::HTML(open(baseurl, :allow_redirections => :all))

doc.search("li.collection-item//a").each do |link|

	title = link.content
	href = link.attr("href")

  slug = href.split("/")[-1]

  sessionurl = baseurl + href

  page = Nokogiri::HTML(open(sessionurl))

	videolink = page.search("video.center//source").first
	videosource = videolink.attr("src")

  urls[slug] = videosource
  p slug
end

end
File.open("videoURLs.json", 'w') do |f|
  f.write(urls.to_json)
end
