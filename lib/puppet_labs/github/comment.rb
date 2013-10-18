require 'json'
require 'puppet_labs/github/issue'
require 'puppet_labs/github/event_base'

module PuppetLabs
module Github

# This class provides a model of a GitHub comment.
#
# @see http://developer.github.com/v3/issues/comments/
class Comment < PuppetLabs::Github::EventBase
  # Comment data
  attr_reader :body,
    :issue,
    :pull_request,
    :author_login,
    :author_avatar_url

  def load_json(json)
    data = JSON.load(json)
    @body = data['comment']['body']
    @action = data['action']
    @issue = ::PuppetLabs::Github::Issue.from_json(json)
    @pull_request = @issue.pull_request
    @repo_name = @issue.repo_name
    @author_login = data['sender']['login']
    @author_avatar_url = data['sender']['avatar_url']
  end

  # This determines whether the comment was on a Pull Request or Issue
  #
  # @returns [Boolean] true/false
  def pull_request?
    !!issue.pull_request.html_url
  end

  def event_description
    "(comment) #{repo_name} #{issue.number}"
  end
end
end
end
