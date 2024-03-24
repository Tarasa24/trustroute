module Keyservers
  # Interface for keyserver implementations
  # All keyserver implementations should inherit from this class
  # and implement the following methods
  class KeyserverBase
    class KeyserverError < StandardError; end

    # Querries the keyserver for a key with the given fingerprint
    # @param fingerprint [String] the fingerprint to search for
    # @return [GPGME::Key] the key if found
    # @return [nil] if no key was found
    # @raise [KeyserverError] if the keyserver returns an error
    def search_by_fingerprint(fingerprint)
      raise NotImplementedError
    end

    # Querries the keyserver for a key with the given key_id
    # @param key_id [String] the key_id to search for
    # @return [GPGME::Key] the key if found
    # @return [nil] if no key was found
    # @raise [KeyserverError] if the keyserver returns an error
    def search_by_key_id(key_id)
      raise NotImplementedError
    end

    # Querries the keyserver for a key with the given email
    # @param email [String] the email to search for
    # @return [GPGME::Key] the key if found
    # @return [nil] if no key was found
    # @raise [KeyserverError] if the keyserver returns an error
    def search_by_email(email)
      raise NotImplementedError
    end

    def self.to_s
      name
    end
  end
end
