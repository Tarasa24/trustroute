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

export default async function fetchGraphData() {
  const res = await fetch("/graph/data")
    .catch(handleError);
  if (res === null) return null;

  const data = await res.json()
    .catch(handleError);
  if (data === null) return null;
  if (!validateData(data)) return null;

  return data;
}
