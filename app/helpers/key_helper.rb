module KeyHelper
  def should_show_vouch_button(key)
    current_key.present? && key != current_key && !current_key.vouches_for?(key)
  end
end
