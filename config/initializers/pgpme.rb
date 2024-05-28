home_dir = ENV.fetch("GNUPGHOME", Rails.root.join(".gnupg").to_s)
GPGME::Engine.home_dir = home_dir

# Ensure that the home directory exists
FileUtils.mkdir_p(home_dir)

# if common.conf does not exist, initialize gpg directory
pubring = File.join(home_dir, "pubring.kbx")
unless File.exist?(pubring)
  gpg_bin = GPGME::Engine.info.first.file_name
  system("#{gpg_bin} --homedir #{home_dir} --list-keys")
end

# Set permissions
system("find #{home_dir} -type f -exec chmod 600 {} \\;")
system("find #{home_dir} -type d -exec chmod 700 {} \\;")

# Monkey patch GPGME::UserID to include ActiveModel::Serialization for JSON serialization needed for elasticsearch indexing
module GPGME
  class UserID
    include ActiveModel::Serialization

    def attributes
      {
        name: name,
        email: email,
        comment: comment,
        uid: uid
      }
    end
  end
end