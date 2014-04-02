
# Create the blank plot
defs = plot.center.append("defs")

defs.append("clipPath")
    .attr("id", "clip-plot")
  .append("rect")
    .attr(
        "width": plot.width + 40
        "height": plot.height)

clip = plot.center.append("g")
    .attr("clip-path", "url(#clip-plot)") # not sure if I'll do zoom

# Create lines
g_lines = clip.selectAll(".line")
    .data(plot.data)
  .enter().append("g")
    .attr(
          "class": "line"
          "id": (d,i) -> "line-#{i}")

line = d3.svg.line()
    .interpolate(interpolate)
    .x((d) -> plot.scales.x(d.x))
    .y((d) -> plot.scales.y(d.y))

lines = g_lines.append("path")
    .attr(
        "d": line
        "fill": "none"
        "stroke": (d) -> r_color_group(d[0])
        "stroke-width": (d) -> d[0].line_stroke_width
        "opacity": (d) -> d[0].line_opacity
        "stroke-dasharray" : (d) -> d[0].line_stroke_dasharray)
    .on('mouseover', (d, i) ->
        d3.select(this.parentNode).classed("hover", true))
    .on('mouseout',  (d, i) ->
        d3.select(this.parentNode).classed("hover", false))

# Create tip
tip = d3.tip()
    .attr('class', 'd3-tip')
    .offset([-15, 0])
    .html(tooltip_content)

clip.call(tip);

# Create line names
line_names = g_lines.append("text")
    .text((d) -> d[0].line_name)
    .attr(
        "y": (d) -> plot.scales.y(d[d.length-1].y)
        "x": (d) -> plot.scales.x(d[d.length-1].x)
        "dy": ".32em"
        "opacity": (d,i) -> d[0].line_opacity
        "dx": 8
        "text-anchor": "left"
        "display": "none")
    .style(
        "fill": (d) -> r_color_group(d[0])
        "font-size": "22px")
    .on('mouseover', (d, i) ->
        d3.select(this.parentNode).classed("hover", true))
    .on('mouseout',  (d, i) ->
        d3.select(this.parentNode).classed("hover", false))

# create points
transform_points = (d) ->
    "translate(#{plot.scales.x(d.x) + plot.jitters.x()}, #{plot.scales.y(d.y) + plot.jitters.y()})"

point_data = d3.merge(plot.data)
g_points = clip.selectAll(".point")
    .data(point_data)
  .enter().append("g")
    .attr(
          "class": "point"
          "transform": transform_points)

points = g_points.append("svg:circle")
    .attr(
        "r": (d) -> d.radius
        "id": (d,i) -> "point-#{i}"
        "fill": (d) -> r_color_group(d)
        "stroke": "black"
        "stroke-width": stroke_width
        "opacity": (d) -> d.point_opacity
        "title": tooltip_content )
    .on('mouseover', (d, i) ->
        point = clip.select('circle#point-'+i)
        d3.select(this.parentNode).classed("hover", true)
        tip.show(point.datum(), point.node()))
    .on('mouseout',  (d, i) ->
        d3.select(this.parentNode).classed("hover", false)
        tip.hide())



# Sidebar
if show_sidebar
    sidebar = plot.right_region.append("g")
        .attr("transform","translate(60,0)")

    g_toggle_names = sidebar.append("g")
        .style("cursor", "pointer")
        .style("font-size","22px")
        .on("click", ()-> toggle_names())

    g_toggle_names.append("circle")
        .attr("r", 7)
        .attr("stroke","black")
        .attr("stroke-width", 2)
        .attr("fill","white")

    g_toggle_names.append("text")
        .attr('text-anchor', 'start')
        .attr('dy', '.32em')
        .attr('dx', '12')
        .text("Show names (#{plot.data.length})")

    toggle_names = ()->
        showing_names = g_toggle_names.classed("show_names")
        line_names.attr("display", ()-> if showing_names then "none" else "inline")
        g_toggle_names.attr("class", ()-> if showing_names then "" else "show_names")
            .select("circle").attr("fill", ()-> if showing_names then "white" else "black")

    # Draw color legend only when there is more than one color
    if color_scale.range().length > 1
        g_color_title = sidebar.append("text")
            .attr(
                  "x": -static_line_width
                  "y": distance_between_show_names_and_color_groups
                  "dy": ".35em")

        g_color_title.append("tspan")
            .style(
                  "font-size": "16px"
                  "font-weight": "bold")
            .text(plot.color_title)

        if color_scale.range().length > 2
            single_group = g_color_title.append("tspan")
                .attr(
                    "fill": "#949494"
                    "dx": "20px")
                .style(
                    "font-size": "16px"
                    "font-weight": "bold")
                .text("Show one")
                .on("click", ()-> deselect_color_groups())

        g_color_group_keys = sidebar.selectAll(".color_group_key")
            .data(color_scale.domain().reverse())
          .enter().append("g")
            .attr(
                  "transform": (d, i) -> "translate(0, #{i * (static_line_width * 2 + 15) + distance_between_show_names_and_color_groups + 30})"
                  "class": "color_group_key")
            .style("cursor", "pointer")

        g_color_group_keys.append("circle")
            .attr(
                "r": static_line_width
                "fill": color_scale)
            .on("click", (d)-> toggle_lines_and_points(d))

        g_color_group_keys.append("text")
            .attr(
                "x": static_line_width + 10
                "y": 0
                "dy": ".35em")
            .text((d) -> "#{d} (#{color_legend_counts[d]})")
            .on("click", (d)-> toggle_lines_and_points(d))

# Aux functions
show_all_colors = () ->
    g_points.classed("hide", false)
    g_lines.classed("hide", false)
    g_color_group_keys.classed("hide", false)
    single_group.text("Show one")

toggle_lines_and_points = (color_groups)->
    # if the elements with the color_groups were hidden, then show; if not hidden, hide.
    g_points.filter((d)-> d.color_group == color_groups).classed("hide", ()->
        !d3.select(this).classed("hide")
    )
    g_lines.filter((d)-> d[0].color_group == color_groups).classed("hide", ()->
        !d3.select(this).classed("hide")
    )

    g_color_group_keys.filter((d)-> d == color_groups).classed("hide", ()->
        !d3.select(this).classed("hide")
    )

    color_groups = g_lines.filter(":not(.hide)").data().map((d)-> d[0].color_group).unique()

    if color_groups.length == 0
        show_all_colors()
    else if color_groups.length == 1
        single_group.text("Show all")
    else
        single_group.text("Show one")


deselect_color_groups = ()->
    visible_points = g_points.filter(":not(.hide)")
    visible_lines = g_lines.filter(":not(.hide)")
    color_groups = visible_lines.data().map((d)-> d[0].color_group).unique()
    if single_group.text() == "Show one"
        visible_color_groups = color_groups.reverse()[0]

        g_points.filter((d)-> d.color_group != visible_color_groups).classed("hide", true)
        g_lines.filter((d)-> d[0].color_group != visible_color_groups).classed("hide", true)
        g_color_group_keys.filter((d)-> d != visible_color_groups).classed("hide", true)
        single_group.text("Show all")
    else
        show_all_colors()

d3.select(".g-search")
    .style(
       "top": "#{g_toggle_names.node().getBoundingClientRect().top + distance_between_show_names_and_color_groups/2 }px"
       "left": "#{g_toggle_names.node().getBoundingClientRect().left}px")

keyuped = () ->
    if (d3.event.keyCode == 27) # pressing Esc on search bar
        this.value = ""

    search(this.value.trim())

search = (value) ->
    if (value)
        re = new RegExp("#{d3.requote(value)}", "i")

        clip.classed("g-searching", true)

        # reset color group selections
        if (sidebar.selectAll(".color_group_key").size() > 0)
            g_color_group_keys.classed("hide", false)
            g_lines.classed("hide", false)

        g_lines.classed("g-match", (d)->
            re.test(d[0].line_name)
        )
        g_points.classed("g-match", (d)->
            re.test(d.line_name)
        )

        line_matches = d3.selectAll(".line.g-match")
        point_matches = d3.selectAll(".point.g-match")
        if (line_matches[0].length == 1)
            mouseover(line_matches, point_matches)
        else
            mouseout()

        search_clear.style("display", null)

    else
        mouseout()
        clip.classed("g-searching", false)
        g_lines.classed("g-match", false)
        search_clear.style("display", "none")

mouseover = (line, point) ->
    last_point_index = line.datum().length - 1
    tip.show(line.datum()[last_point_index], point[0][last_point_index])

mouseout = () ->
    tip.hide()

search_input = d3.select(".g-search input")
    .on("keyup", keyuped);

search_clear = d3.select(".g-search .g-search-clear")
    .on("click", () ->
        search_input.property("value", "")
        search()
    )

