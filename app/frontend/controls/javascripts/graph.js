import graphCanvas from './graph_canvas.js';
import fetchGraphData from './graph_data.js';

async function renderGraph() {
  if (document.location.pathname != '/') return;
  const data = await fetchGraphData();
  if (data === null) return;

  const onClick = (event, d) => {
    Turbo.visit(`/keys/${d.id}`, re
  };

  document.getElementById('chart')
    .appendChild(graphCanvas(data, onClick));
}

document.addEventListener('DOMContentLoaded', () => renderGraph());
document.addEventListener("turbo:render", () => renderGraph());