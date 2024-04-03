module IdentityHelper
  def identity_icon(identity)
    if identity.provider == :twitter2
      content_tag(:div, "", class: "fa-brands fa-x-twitter")
    else
      content_tag(:div, "", class: "fa-brands fa-#{identity.provider}")
    end
  end

  def identity_name(identity)
    identity.name
  end

  def identity_supliment(identity)
    identity.nickname
  end

  def identity_link(identity)
    case identity.provider
    when :github
      "https://github.com/#{identity.nickname}"
    when :twitter2
      "https://twitter.com/#{identity.nickname}"
    when :discord
      ""
    else
      "#"
    end
  end
end
