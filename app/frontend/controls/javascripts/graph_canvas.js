import * as d3 from 'd3';
import graphInteractions from './graph_interactions';
import { WIDTH, HEIGHT, BACKGROUND_COLOR, LINK_COLOR, NODE_COLOR, SELF_NODE_COLOR, TEXT_COLOR, ARROW_COLOR } from './graph_constants';

function createSVG() {
  return d3.create('svg')
    .attr('width', WIDTH)
    .attr('height', HEIGHT)
    .style('background-color', BACKGROUND_COLOR);
}

function appendLinks(svg, links) {
  return svg.append("g")
    .attr("fill", "none")
    .attr("stroke", LINK_COLOR)
    .attr("stroke-width", 1.5)
    .selectAll("path")
    .data(links)
    .join("path")
    .attr("marker-end", "url(#arrowhead)")
    .attr("class", "link");
}

function appendNodes(svg, nodes) {
  const node = svg.append("g")
    .selectAll("g")
    .data(nodes)
    .join("g");

  node.append("circle")
    .attr("r", 8)
    .attr("fill", d => d.is_self ? SELF_NODE_COLOR : NODE_COLOR)
    .attr("cursor", "pointer");

  node.append("text")
    .attr("x", 12)
    .attr("y", "0.31em")
    .text(d => d.sha)
    .attr("fill", TEXT_COLOR);

  node.attr("class", "node");

  return node;
}

export default function graphCanvas(data) {
  const nodes = data.nodes;
  const links = data.links;

  const svg = createSVG();

  svg.append('defs').append('marker')
    .attr("id", "arrowhead")
    .attr("viewBox", "-6 -6 12 12")
    .attr("refX", 12)
    .attr("refY", -3)
    .attr("markerWidth", 6)
    .attr("markerHeight", 6)
    .attr("orient", "auto")
    .append("svg:path")
    .attr("fill", ARROW_COLOR)
    .attr("d", "M-6,-6L6,0L-6,6Z");

  appendLinks(svg, links);
  appendNodes(svg, nodes);
  graphInteractions(svg);

  return svg.node();
}
