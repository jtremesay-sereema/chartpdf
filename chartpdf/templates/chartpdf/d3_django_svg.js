const jsdom = await import("jsdom")
const d3 = await import("d3")


function cp_scatter_with_points(svg, points) {
    svg.attr("viewBox", [0, 0, 800, 600])

    // Add debug background
    svg.append("rect",)
        .attr("width", 800)
        .attr("height", 600)
        .attr("fill", "magenta")

    // Draw the points
    svg.selectAll(".cf-point")
        .data(points)
        .join("circle")
        .attr("cx", p => p.x * 800)
        .attr("cy", p => p.y * 600)
        .attr("r", 4)
        .attr("fill", "green")

    return svg
}

const dom = new jsdom.JSDOM(`<svg width="800" height="600"></svg>`);
let svg = d3.select(dom.window.document).select("svg")
let points = {{ points|safe }}
return cp_scatter_with_points(svg, points).node().outerHTML
