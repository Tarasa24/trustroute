import graphCanvas from './graph_canvas.js';
import fetchGraphData, { fetchLocalGraphData, saveLocalGraphData } from './graph_data.js';

async function renderGraph() {
  const container = document.getElementById('chart');
  if (container === null) return;

  const data = await fetchGraphData();
  if (data === null) return;

  container.innerHTML = '';
  container.appendChild(graphCanvas(data));

  // Clear the saved graph state and snapshot from local storage
  localStorage.removeItem('graph_data');
  localStorage.removeItem('graph_svg');
}

function saveGraph() {
  const container = document.getElementById('chart');
  if (container === null) return;

  saveLocalGraphData(container);
  localStorage.setItem('graph_svg', container.innerHTML);
}

async function reRenderGraph() {
  const container = document.getElementById('chart');
  if (container === null) return;

  // Initially display svg snapshot from local storage
  const svg = localStorage.getItem('graph_svg');
  if (svg !== null) container.innerHTML = svg;

  // Start fetching and preparing the new state
  const data = await fetchLocalGraphData();
  if (data === null) return renderGraph(); // We should re-fetch

  // Finally clear the container and render the new graph
  container.innerHTML = '';
  container.appendChild(graphCanvas(data));

  // Clear the snapshot from local storage
  localStorage.removeItem('graph_svg');
}

document.addEventListener('DOMContentLoaded', () => renderGraph());
document.addEventListener('turbo:before-visit', () => saveGraph());
document.addEventListener("turbo:render", () => reRenderGraph());