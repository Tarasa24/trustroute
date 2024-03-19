module IdentityHelper
  def identity_icon(identity)
    if identity.instance_of?(::OAuthIdentity)
      if identity.provider == :twitter2
        content_tag(:div, "", class: "fa-brands fa-x-twitter")
      else
        content_tag(:div, "", class: "fa-brands fa-#{identity.provider}")
      end
    else
      content_tag(:div, "", class: "fa-solid fa-question")
    end
  end

  def identity_name(identity)
    if identity.instance_of?(::OAuthIdentity)
      identity.info["name"]
    else
      "Unknown"
    end
  end

  def identity_supliment(identity)
    if identity.instance_of?(::OAuthIdentity)
      identity.info["nickname"]
    end
  end

  def identity_link(identity)
    "#"
  end
end
