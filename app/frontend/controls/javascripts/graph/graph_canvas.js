import * as d3 from 'd3';
import graphInteractions from './graph_interactions';
import {
  BACKGROUND_COLOR, LINK_COLOR,
  NODE_COLOR, SELF_NODE_COLOR, TEXT_COLOR, ARROW_COLOR,
  TARGET_NODE_COLOR, PATH_COLOR
} from './graph_constants';

function createSVG() {
  return d3.create('svg')
    .style('background-color', BACKGROUND_COLOR);
}

function appendLinks(svg, links) {
  const fillColor = (d) => {
    if (d.active) return PATH_COLOR;
    return LINK_COLOR;
  };
  const marker = (d) => {
    if (d.active) return "url(#arrowhead-active)";
    return "url(#arrowhead)";
  };

  return svg.append("g")
    .attr("fill", "none")
    .attr("stroke-width", 1.5)
    .selectAll("path")
    .data(links)
    .join("path")
    .attr("stroke", fillColor)
    .attr("marker-end", marker)
    .attr("class", "link");
}

function appendNodes(svg, nodes) {
  const node = svg.append("g")
    .selectAll("g")
    .data(nodes)
    .join("g");

  const fillColor = (d) => {
    if (d.is_self) return SELF_NODE_COLOR;
    if (d.is_target) return TARGET_NODE_COLOR;
    return NODE_COLOR;
  };

  node.append("circle")
    .attr("r", 8)
    .attr("fill", fillColor)
    .attr("cursor", "pointer");

  node.append("text")
    .attr("x", 12)
    .attr("y", "0.31em")
    .text(d => d.sha)
    .attr("fill", TEXT_COLOR);

  node.attr("class", "node");

  return node;
}

function arrowheadNode(svg, color, id) {
  svg.append('defs').append('marker')
    .attr("id", id)
    .attr("viewBox", "-6 -6 12 12")
    .attr("refX", 12)
    .attr("refY", -3)
    .attr("markerWidth", 6)
    .attr("markerHeight", 6)
    .attr("orient", "auto")
    .append("svg:path")
    .attr("fill", color)
    .attr("d", "M-6,-6L6,0L-6,6Z");

}

function appendArrowheads(svg) {
  arrowheadNode(svg, ARROW_COLOR, "arrowhead");
  arrowheadNode(svg, PATH_COLOR, "arrowhead-active");
}

export default function graphCanvas(data) {
  const nodes = data.nodes;
  const links = data.links;

  const svg = createSVG();

  appendArrowheads(svg);
  appendLinks(svg, links);
  appendNodes(svg, nodes);
  graphInteractions(svg);

  return svg.node();
}
