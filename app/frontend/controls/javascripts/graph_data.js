import * as d3 from 'd3';

export default async function fetchGraphData() {
  const res = await fetch("/graph/data")
    .catch(handleError);
  if (res === null) return null;

  const data = await res.json()
    .catch(handleError);
  if (data === null) return null;
  if (!validateData(data)) return null;

  return transformData(data);
}

export function fetchLocalGraphData() {
  const data = JSON.parse(localStorage.getItem('graph_data'));
  if (!validateData(data)) return null;

  return transformData(data);
}

export function saveLocalGraphData(container) {
  const data = JSON.stringify({
    nodes: d3.select(container).selectAll('.node').data(),
    links: d3.select(container).selectAll('.link').data()
  });

  localStorage.setItem('graph_data', data);
}

export async function fetchPathData(from_id, to_id) {
  const res = await fetch(`/graph/path/${from_id}/${to_id}`)
    .catch(handleError);
  if (res === null) return null;

  const data = res.json()
    .catch(handleError);

  return data;
}

function handleError(e) {
  console.log("Error: ", e);

  return null;
}

function validateData(data) {
  if (data === null) return false;
  if (data.nodes === null) return false;
  if (data.links === null) return false;
  return true;
}

function transformData(data) {
  data.links = data.links.map((l) => {
    if (typeof l.source === 'string' && typeof l.target === 'string') return l;

    // Strip positional data from links, since it will be calculated dynamically
    //  happens when you load from local storage
    return {
      source: l.source.id,
      target: l.target.id
    };
  });

  // get taerget node id from current url /key/:id
  const targetNodeId = window.location.pathname.split('/').pop();
  data.nodes = data.nodes.map((n) => {
    n.is_self = (n.id == document.current_key);
    n.is_target = (n.id == targetNodeId);
    return n;
  });

  return data;
}