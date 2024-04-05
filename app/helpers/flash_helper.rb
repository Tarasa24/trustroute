module FlashHelper
  def flash_icon(level)
    case level.to_sym
    when :notice then "fa-info-circle"
    when :success then "fa-check-circle"
    when :error then "fa-exclamation-circle"
    when :alert then "fa-exclamation-triangle"
    end
  end
end
