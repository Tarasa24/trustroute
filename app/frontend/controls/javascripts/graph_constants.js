import colors from '../../stylesheets/variables.scss?raw';

const colorsObj = {};
for (let line of colors.split("\n")) {
  if (!line.match(/\$.*: (#.*)|(\$.*);/)) continue;

  let [key, value] = line.split(':');
  key = key.trim();
  value = value.replace(';', '').trim();
  colorsObj[key] = value;

  if (value.includes('$')) {
    if (!colorsObj[value]) continue;
    colorsObj[key] = colorsObj[value];
  }
}

export const LINK_COLOR = colorsObj['$LINK_COLOR'];
export const ARROW_COLOR = colorsObj['$ARROW_COLOR'];
export const NODE_COLOR = colorsObj['$NODE_COLOR'];
export const SELF_NODE_COLOR = colorsObj['$SELF_NODE_COLOR'];
export const TARGET_NODE_COLOR = colorsObj['$TARGET_NODE_COLOR'];
export const BACKGROUND_COLOR = colorsObj['$BACKGROUND_COLOR'];
export const TEXT_COLOR = 'white';
export const PATH_COLOR = colorsObj['$PATH_COLOR'];