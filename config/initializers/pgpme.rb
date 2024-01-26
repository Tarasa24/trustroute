return unless Rails.env.development?

home_dir = ENV.fetch("GNUPGHOME", Rails.root.join(".gnupg").to_s)
GPGME::Engine.home_dir = home_dir

# Ensure that the home directory exists
FileUtils.mkdir_p(home_dir)

# if common.conf does not exist, initialize gpg directory
common_conf = File.join(home_dir, "common.conf")
unless File.exist?(common_conf)
  gpg_bin = GPGME::Engine.info.first.file_name
  system("#{gpg_bin} --homedir #{home_dir} --list-keys")
end
