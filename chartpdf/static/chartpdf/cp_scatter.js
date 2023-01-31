function cp_scatter_with_url(svg) {
    let data_src = svg.attr("data-src")
    d3.json(data_src).then((data) => {
        cp_scatter_with_points(svg, data.points)
    })
}

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
        .join(enter => enter.append("circle"), update => update, exit => exit.remove())
        .attr("cx", p => p.x * 800)
        .attr("cy", p => p.y * 600)
        .attr("r", 4)
        .attr("fill", "green")

    return svg
}
