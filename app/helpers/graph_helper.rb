module GraphHelper
  def graph_js_data_string(nodes, links)
    # {
    #   nodes: [
    #     {id: "Myriel", group: 1},
    #     {id: "Napoleon", group: 1},
    #     {id: "Mlle.Baptistine", group: 1},
    #   ],
    #   links: [
    #     {source: "Napoleon", target: "Myriel", value: 1},
    #     {source: "Mlle.Baptistine", target: "Myriel", value: 8},
    #   ]
    # }

    data_string = "window.graph_data = {nodes: ["
    nodes.each do |node|
      data_string += "{id: \"#{node.short_key_id}\", "
      data_string += "group: #{node.master? ? 1 : 0}},"
    end
    data_string += "], links: ["
    links.each do |link|
      data_string += "{source: \"#{link[:from].short_key_id}\", "
      data_string += "target: \"#{link[:to].short_key_id}\", "
      data_string += "value: #{link[:rel].signature_id} },"
    end
    data_string += "]};"

    data_string
  end
end
