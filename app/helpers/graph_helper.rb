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

    data_string = "window.GRAPH_DATA = {nodes: ["
    nodes.each do |node|
      data_string += "{id: \"#{node.sha}\", "
      data_string += "group: #{node.master? ? 1 : 0}},"
    end
    data_string += "], links: ["
    links.each do |link|
      data_string += "{source: \"#{link[:from].sha}\", "
      data_string += "target: \"#{link[:to].sha}\", "
      data_string += "value: #{link[:rel].signature_id} },"
    end
    data_string += "]};"

    data_string
  end
end
