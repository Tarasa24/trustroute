import graphCanvas from './graph_canvas.js';

function renderGraph() {
  if (document.location.pathname != '/') return;
  let graphData = window.GRAPH_DATA; // variable set in views/graph/index.html.slim
  if (!graphData) return;

  document.getElementById('chart')
    .appendChild(graphCanvas(graphData));
}

document.addEventListener('DOMContentLoaded', () => renderGraph());
document.addEventListener("turbo:render", () => renderGraph());