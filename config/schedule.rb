every 1.day, at: "4:00 am" do
  runner "OAuthIdentityRefreshJob.perform_now"
  runner "IdentityCleanerJob.perform_now"
end
