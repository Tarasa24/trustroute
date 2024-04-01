class GPGPackets
  def initialize(gpg)
    gpg = gpg.gsub("-----BEGIN PGP PUBLIC KEY BLOCK-----", "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\n")
    IO.popen("gpg --list-packets", "r+") do |pipe|
      pipe.write(gpg)
      pipe.close_write
      @packets_string = pipe.read
    end

    # Parse the packets, each packet begins with #
    @packets = @packets_string.split("\n").slice_before(/^#/).map do |packet|
      # Remove the first line which is the packet header
      packet.shift
      packet.join("\n")
    end
  end

  def public_key?
    @packets.first&.start_with?(":public key packet:")
  end

  def signature?
    @packets.first&.start_with?(":signature packet:")
  end

  def signature_packets
    @signature_packets ||= @packets.select do |packet|
      packet.start_with?(":signature packet:")
    end.map do |packet|
      SignaturePacket.new(packet)
    end
  end

  def public_key_packet
    return unless public_key?
    @public_key_packet ||= PublicKeyPacket.new(@packets.first)
  end

  class SignaturePacket
    def initialize(packet)
      @packet = packet
    end

    def key_id
      @key_id ||= @packet.match(/keyid\s+([0-9A-F]+)/)[1]
    end
  end

  class PublicKeyPacket
    def initialize(packet)
      @packet = packet
    end

    def key_id
      @key_id ||= @packet.match(/\tkeyid:\s+([0-9A-F]+)/)[1]
    end
  end
end
