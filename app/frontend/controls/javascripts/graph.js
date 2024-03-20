import graphCanvas from './graph_canvas.js';
import fetchGraphData, { fetchLocalGraphData, saveLocalGraphData } from './graph_data.js';

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

  saveLocalGraphData(container);
}

async function reRenderGraph() {
  const container = document.getElementById('chart');
  if (container === null) return;

  // Use the saved graph state from local storage
  const data = await fetchLocalGraphData();
  if (data === null) return renderGraph(); // We should re-fetch

  container.innerHTML = '';
  container.appendChild(graphCanvas(data));
}

document.addEventListener('DOMContentLoaded', () => renderGraph());
document.addEventListener('turbo:before-visit', () => saveGraph());
document.addEventListener("turbo:render", () => reRenderGraph());