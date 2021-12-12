class SendMailJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(payload)
    begin
      RestClient.post(
        "https://api:#{payload["api_key"]}@api.mailgun.net/v3/#{payload["domain"]}/messages",
        :from => payload["from"],
        :to => payload["to"],
        :subject => payload["subject"],
        :html => payload["body"]
      )
    rescue => e
      raise StandardError.new "Failed to post to Mailgun API"
    end
  end
end
