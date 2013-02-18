#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'
require 'github_api'


#issues = Github::Issues.new
#puts issues.list(:org => 'neo4j')

github = Github.new
github.issues.list(:user => 'neo4j', :repo => 'neo4j').each_page do |page|
  page.each do |issue|
    puts issue.title
  end
end


