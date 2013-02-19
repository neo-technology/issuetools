#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'
require 'github_api'

CREDENTIALS = PUT YOUR BASIC AUTH CREDENTIALS HERE AND TRUST THAT THE LIBRARY AUTHOR IS NOT HARVESTING THEM AND YOUR ORGANS
# e.g. CREDENTIALS='foo:bar'

@github = Github.new(basic_auth: CREDENTIALS)

def imported?(comments)
  comments.select { |comment| comment.body.match(/This issue was migrated from /) }.length >= 1
end

def pr?(issue)
  issue.respond_to?(:pull_request)
end

def comments(issue)
  @github.issues.comments.all('neo4j', 'neo4j', issue_id: issue.number)
end

def commented?(comments)
  imported = imported?(comments)
  if imported && comments.length == 1
    false
  elsif !imported && comments.length == 0
    return false
  else
    true
  end
end

begin
  @github.issues.list(:user => 'neo4j', :repo => 'neo4j').each_page do |page|
    page.each do |issue|
      next if pr?(issue)
      comments = comments(issue)
      printf("%3s %-60.60s %-10s\n", issue.number, issue.title, issue.user.login) unless commented?(comments)
      sleep 1 # be kind to github
    end
  end
rescue Github::Error::Forbidden => e
  puts "It looks like you displeased GitHub: #{e.message}"
end




