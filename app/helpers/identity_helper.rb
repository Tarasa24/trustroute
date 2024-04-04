module IdentityHelper
  # rubocop:disable Style/ClassEqualityComparison
  def identity_icon(identity)
    if identity.class.name == "OAuthIdentity"
      if identity.provider == :twitter2
        content_tag(:div, "", class: "fa-brands fa-x-twitter")
      else
        content_tag(:div, "", class: "fa-brands fa-#{identity.provider}")
      end
    elsif identity.class.name == "DNSIdentity"
      content_tag(:div, "", class: "fa-solid fa-globe")
    end
  end

  def identity_name(identity)
    if identity.class.name == "OAuthIdentity"
      identity.name
    elsif identity.class.name == "DNSIdentity"
      identity.domain
    end
  end

  def identity_supliment(identity)
    if identity.class.name == "OAuthIdentity"
      identity.nickname
    end
  end

  def identity_link(identity)
    if identity.class.name == "OAuthIdentity"
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
    elsif identity.class.name == "DNSIdentity"
      "https://#{identity.domain}"
    end
  end
  # rubocop:enable Style/ClassEqualityComparison
end
