import graphCanvas from './graph_canvas.js';
import fetchGraphData, { fetchLocalGraphData, saveLocalGraphData, fetchPathData } from './graph_data.js';

async function renderGraph() {
  const container = document.getElementById('chart');
  if (container === null) return;

  const data = await fetchGraphData();
  if (data === null) return;

  if (window.location.pathname.match(/\/keys\/[a-f0-9-]+/)) {
    const path = window.location.pathname.split('/');
    const from_id = document.current_key;
    const to_id = path.pop();
    const pathData = await fetchPathData(from_id, to_id);
    if (pathData === null) return;

    pathData.forEach((segment) => {
      segment.active = true;
    });

    data.links = data.links.map((l) => {
      l.active = false;
      pathData.forEach((segment) => {
        if (l.source === segment.source && l.target === segment.target) {
          l.active = true;
        }
      });

      return l;
    });
  }

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

function reRenderGraph() {
  const container = document.getElementById('chart');
  if (container === null) return;

  // Use the saved graph state from local storage
  const data = fetchLocalGraphData();
  if (data === null) return renderGraph(); // We should re-fetch

  container.innerHTML = '';
  container.appendChild(graphCanvas(data));
}

document.addEventListener('DOMContentLoaded', () => renderGraph());
document.addEventListener('turbo:before-visit', () => saveGraph());
document.addEventListener("turbo:render", () => reRenderGraph());