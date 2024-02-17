import * as d3 from 'd3';

const WIDTH = 928;
const HEIGHT = 600;
const ARROW_COLOR = 'grey';
const NODE_COLOR = 'steelblue';
const LINK_COLOR = 'lightblue';

function createSVG() {
  return d3.create('svg')
    .attr('width', WIDTH)
    .attr('height', HEIGHT)
    .style('background-color', 'lightgrey');
}

function createSimulation(nodes, links) {
  return d3.forceSimulation(nodes)
    .force("link", d3.forceLink(links).id(d => d.id))
    .force("charge", d3.forceManyBody().strength(-400))
    .force("x", d3.forceX())
    .force("y", d3.forceY());
}

function appendLinks(svg, links) {
  return svg.append("g")
    .attr("fill", "none")
    .attr("stroke", LINK_COLOR)
    .attr("stroke-width", 1.5)
    .selectAll("path")
    .data(links)
    .join("path")
    .attr("marker-end", "url(#arrowhead)");
}

function appendNodes(svg, nodes, simulation, onClick) {
  const node = svg.append("g")
    .attr("fill", NODE_COLOR)
    .attr("stroke", "white")
    .attr("stroke-width", 1.5)
    .selectAll("g")
    .data(nodes)
    .join("g")
    .call(drag(simulation))
    .on("click", onClick);

  node.append("circle")
    .attr("r", 8);

  node.append("text")
    .attr("x", 12)
    .attr("y", "0.31em")
    .text(d => d.sha)
    .clone(true).lower()
    .attr("fill", "none")
    .attr("stroke", "white")
    .attr("stroke-width", 3);

  return node;
}

function drag(simulation) {
  function dragstarted(event, d) {
    if (!event.active) simulation.alphaTarget(0.3).restart();
    d.fx = d.x;
    d.fy = d.y;
  }

  function dragged(event, d) {
    d.fx = event.x;
    d.fy = event.y;
  }

  function dragended(event, d) {
    if (!event.active) simulation.alphaTarget(0);
    d.fx = null;
    d.fy = null;
  }

  return d3.drag()
    .on("start", dragstarted)
    .on("drag", dragged)
    .on("end", dragended);
}

function linkArc(d, centerX, centerY) {
  const sourceX = d.source.x + centerX;
  const sourceY = d.source.y + centerY;
  const targetX = d.target.x + centerX;
  const targetY = d.target.y + centerY;
  const r = Math.hypot(targetX - sourceX, targetY - sourceY);
  return `
    M${sourceX},${sourceY}
    A${r},${r} 0 0,1 ${targetX},${targetY}
  `;
}


export default function graphCanvas(data, onClick) {
  const nodes = data.nodes;
  const links = data.links;

  const svg = createSVG();

  const simulation = createSimulation(nodes, links);

  const arrowhead = svg.append('defs').append('marker')
    .attr("id", "arrowhead")
    .attr("viewBox", "-6 -6 12 12")
    .attr("refX", 0)
    .attr("refY", 0)
    .attr("markerWidth", 6)
    .attr("markerHeight", 6)
    .attr("orient", "auto")
    .append("path")
    .attr("fill", ARROW_COLOR)
    .attr("d", "M-6,-6L6,0L-6,6Z");

  const link = appendLinks(svg, links);

  const node = appendNodes(svg, nodes, simulation, onClick);

  simulation.on("tick", () => {
    link.attr("d", d => linkArc(d, WIDTH / 2, HEIGHT / 2));
    node.attr("transform", d => `translate(${d.x + WIDTH / 2},${d.y + HEIGHT / 2})`);
  });

  return svg.node();
}
