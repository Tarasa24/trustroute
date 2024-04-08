module PropertyEncryptable
  extend ActiveSupport::Concern

  included do
    def self.property_encryptable(*properties)
      properties.each do |property|
        unless property.to_s.start_with?("encrypted_")
          raise ArgumentError, "property must start with 'encrypted_'"
        end

        virtual_property = property.to_s.gsub("encrypted_", "")
        define_method(virtual_property) do
          return instance_variable_get("@#{virtual_property}") if instance_variable_defined?("@#{virtual_property}")

          return nil if send(property).blank?

          instance_variable_set("@#{virtual_property}", decrypt(send(property)))
        end

        define_method("#{virtual_property}=") do |value|
          send("#{property}=", encrypt(value))
          instance_variable_set("@#{virtual_property}", value)
        end

        define_method("#{property}=") do |value|
          instance_variable_set("@#{virtual_property}", nil)
          super(value)
        end

        validate :"validate_#{virtual_property}_base64", if: -> { send(property).present? }

        private

        define_method("validate_#{virtual_property}_base64") do
          return if send(property).blank?

          Base64.strict_decode64(send(property))
        rescue ArgumentError
          errors.add(property, "is not in base64 format")
        end
      end
    end
  end

  def encrypt(value)
    return nil if value.blank?

    cipher = OpenSSL::Cipher.new("aes-256-cbc")
    cipher.encrypt
    cipher.key = secret_key_base[0..31]
    cipher.iv = secret_key_base[0..15]
    Base64.strict_encode64(cipher.update(value) + cipher.final)
  end

  def decrypt(value)
    return nil if value.blank?

    cipher = OpenSSL::Cipher.new("aes-256-cbc")
    cipher.decrypt
    cipher.key = Rails.application.credentials.secret_key_base[0..31]
    cipher.iv = Rails.application.credentials.secret_key_base[0..15]
    cipher.update(Base64.strict_decode64(value)) + cipher.final
  end
end
