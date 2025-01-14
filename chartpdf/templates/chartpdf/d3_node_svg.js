{% load inline_static_tags %}

import * as jsdom from 'jsdom';
import * as d3 from 'd3';

{% inline_javascript "chartpdf/cp_scatter.js" %}

const dom = new jsdom.JSDOM(`<svg width="800" height="600"></svg>`);
let svg = d3.select(dom.window.document).select("svg")
let points = {{ points|safe }}

console.log(cp_scatter_with_points(svg, points).node().outerHTML)
