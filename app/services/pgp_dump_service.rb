class PGPDumpService
  def initialize(key)
    if key.is_a?(GPGME::Key) || key.is_a?(GPGME::SubKey)
      @key_string = key.export.to_s
    elsif key.is_a?(String)
      @key_string = key
    else
      raise ArgumentError, "Key must be a GPGME::Key, GPGME::SubKey or a String"
    end
  end

  def call
    IO.popen("pgpdump -i", "r+") do |pipe|
      pipe.write(@key_string)
      pipe.close_write
      pipe.read
    end
  end
end
