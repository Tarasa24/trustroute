module Keyservers
  # Query mechanism for Ubuntu keyserver
  class KeyserverUbuntuCom < KeyserverBase
    include HTTParty
    base_uri "https://keyserver.ubuntu.com/pks/lookup?op=get&options=mr&search="

    def search_by_query(query)
      import_key(fetch_key(query))
    end

    alias_method :search_by_key_id, :search_by_query
    alias_method :search_by_email, :search_by_query
    alias_method :search_by_fingerprint, :search_by_query

    def self.to_s
      "keyserver.ubuntu.com"
    end

    private

    # Import a key from a string into the local keyring
    # @param armored_key [String] the armored key to import
    # @return [GPGME::Key] the imported key
    def import_key(armored_key)
      imported = GPGME::Key.import(armored_key).imports.first
      raise KeyserverError, "Key import failed" unless imported

      GPGME::Key.get(imported.fpr)
    end

    # Fetches a key from the keyserver
    # @param query [String] the query to send to the keyserver
    # @return [String] the armored key
    # @raise [KeyserverError] if the keyserver returns an error
    def fetch_key(query)
      response = self.class.get(query)
      return response.body if response.success?

      raise KeyserverError, "Keyserver returned #{response.code} #{response.message}"
    end
  end
end
