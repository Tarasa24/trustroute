class IdentityCleanerJob < ApplicationJob
  queue_as :default

  def perform
    identities.each do |identity|
      if identity.created_at > 1.week.ago && !identity.validated?
        identity.destroy
      end
    end
  end

  private

  def identities
    @identities ||= begin
      # Created a week ago and not validated
      email_ident = EmailIdentity
        .query_as(:i)
        .where("i.created_at < $week_ago AND i.validated = false", week_ago: 1.week.ago.to_i)
        .pluck(:i)
      dns_ident = DNSIdentity
        .query_as(:i)
        .where("i.created_at < $week_ago AND i.validated = false", week_ago: 1.week.ago.to_i)
        .pluck(:i)

      email_ident + dns_ident
    end
  end
end
