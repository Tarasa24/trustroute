require "dry-initializer"

class ApplicationService
  extend Dry::Initializer

  def initialize(*params)
    @error = nil

    super(*params)
  end

  def call
    raise NotImplementedError
  end

  def success?
    @error.nil?
  end

  def error_key
    @error&.first
  end

  def error_message
    @error&.last
  end

  private

  def error(error_key, message)
    @error = [error_key, message]

    false
  end
end
