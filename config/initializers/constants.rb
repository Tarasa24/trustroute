KEYSERVERS = Keyserver.constants
  .map(&Keyserver.method(:const_get))
  .select { |constant| constant.is_a? Class }
  .delete_if { |klass| klass == Keyserver::KeyserverBase }
  .freeze
