module IdentityHelper
  def identity_icon(identity)
    if identity.provider == :twitter2
      content_tag(:div, "", class: "fa-brands fa-x-twitter")
    else
      content_tag(:div, "", class: "fa-brands fa-#{identity.provider}")
    end
  end

  def identity_name(identity)
    identity.info["name"]
  end

  def identity_supliment(identity)
    identity.info["nickname"]
  end

  def identity_link(identity)
    "#"
  end
end
