import * as d3 from 'd3';
import graphCanvas from './graph_canvas.js';
import fetchGraphData from './graph_data.js';

async function renderGraph() {
  const container = document.getElementById('chart');
  if (container === null) return;

  const data = await fetchGraphData();
  if (data === null) return;

  container.innerHTML = '';
  container.appendChild(graphCanvas(data));

  // Clear the saved graph state from local storage
  localStorage.removeItem('graph_data');
}

function saveGraph() {
  const container = document.getElementById('chart');
  if (container === null) return;

  const data = JSON.stringify({
    nodes: d3.select(container).selectAll('.node').data(),
    links: d3.select(container).selectAll('.link').data().map((l) => (
      // Strip positional data from links, since it will be calculated dynamically
      {
        source: l.source.id,
        target: l.target.id
      }
    ))
  });

  localStorage.setItem('graph_data', data);
}

function reRenderGraph() {
  const container = document.getElementById('chart');
  if (container === null) return;

  // Use the saved graph state from local storage
  const data = JSON.parse(localStorage.getItem('graph_data'));
  if (data === null) return;

  container.innerHTML = '';
  container.appendChild(graphCanvas(data));
}

document.addEventListener('DOMContentLoaded', () => renderGraph());
document.addEventListener('turbo:before-visit', () => saveGraph());
document.addEventListener("turbo:render", () => reRenderGraph());