        chartname = "#plot"

        d3.json {{ get_data_as_json_file(opts) }}, (data) -> 

          svgscale = plotframe(data, {
            chartname: chartname,
            xlab:   {{ quote_escaped(opts$params$x_axis_label) }},
            ylab:   {{ quote_escaped(opts$params$y_axis_label) }},
            height: {{ opts$params$height }},
            width:  {{ opts$params$width }},
            pad:    {{ get_padding_param(opts) }},
            tickPadding: {{ opts$params$tick_padding }},
            scalePadding: {{ opts$params$scale_padding }}
          })

          colors =  d3.scale.category10()

          svgscale.svg.selectAll("circle", {chartname: chartname})
            .data(data)
            .enter()
            .append("circle")
            .attr("cx", (d) -> svgscale.x d.x)
            .attr("cy", (d) -> svgscale.y d.y)
            .attr("r", 5)
            .attr("fill", (d) -> colors(d.group))
            .on("mouseover", ->
                d3.select(this).transition().attr("fill", "black")
            ).on("mouseover.tooltip", (d,i) ->
                svgscale.svg.append("text")
                  .text("#{d.name} #{d.group}")
                  .attr("id", "tooltip")
                  .attr("x", svgscale.x(d.x) + 10)
                  .attr("y", svgscale.y(d.y))
                  .attr("fill","black")
                  .attr("opacity",0).style("font-family", "sans-serif").transition().attr("opacity", 1)
            )
            .on("mouseout", (d) ->
                d3.select(this).transition().duration(500).attr("fill", (d) -> colors(d.group))
                d3.selectAll("#tooltip").transition().duration(500).attr("opacity",0).remove()
            )
