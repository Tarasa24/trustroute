import * as d3 from 'd3';
import { WIDTH, HEIGHT } from './graph_constants';

export default function graphInteractions(svg) {
  svg.selectAll(".node")
    .on("click", (_event, d) => {
      Turbo.visit(`/keys/${d.id}`);
    });

  createSimulation(svg);
}

function createSimulation(svg) {
  const svgLinks = svg.selectAll(".link");
  const svgNodes = svg.selectAll(".node");

  const simulation = d3.forceSimulation(svgNodes.data())
    .force("link", d3.forceLink(svgLinks.data()).strength(1e-3).id(d => d.id))
    .force("charge", d3.forceManyBody().strength(-400))
    .force("x", d3.forceX())
    .force("y", d3.forceY());

  simulation.on("tick", () => {
    svgLinks.attr("d", d => linkArc(d, WIDTH / 2, HEIGHT / 2));
    svgNodes.attr("transform", d => `translate(${d.x + WIDTH / 2},${d.y + HEIGHT / 2})`);
  });

  svgNodes.call(drag(simulation));
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
    M${sourceX}, ${sourceY}
    A${r}, ${r} 0 0, 1 ${targetX}, ${targetY}
    `;
};