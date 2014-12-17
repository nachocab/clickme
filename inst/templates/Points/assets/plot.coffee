plot.get_band_widths = ()->
    plot.band_widths = {}
    plot.band_widths.x = get_band_width(plot, "x")
    plot.band_widths.y = get_band_width(plot, "y")
    plot

plot.get_jitters = ()->
    # don't confuse plot.jitters (d3-defined function)
    # with plot.jitter (user defined value)
    plot.jitters = {}
    plot.jitters.x = get_jitter(plot, "x")
    plot.jitters.y = get_jitter(plot, "y")
    plot

get_jitter = (plot, scale_name) ->
    band_width = plot.band_widths[scale_name]
    jitter_pct = plot.jitter[scale_name] # 1 is maximum dispersion, 0 is no dispersion.
    group_jitter_pct = plot.group_jitter[scale_name] || jitter_pct # 1 is maximum dispersion, 0 is no dispersion.
    if plot.jitter_type[scale_name] == "grouped" && plot.data[0].color_group?
        # we're assuming that every element will have a color_group property
        color_groups = (elem.color_group for elem in plot.data).unique().reverse()
        group_band_width = band_width/color_groups.length
        band_indeces = get_band_indeces(color_groups.length)
        jitter = (color_group)->
            color_group_index = color_groups.indexOf(color_group)
            (group_band_width/2 * jitter_pct * random()) + (group_band_width * group_jitter_pct * band_indeces[color_group_index])
    else
        jitter = ()->
            band_width/2 * jitter_pct * random()
    jitter

# size of bands (in pixels), useful for jitters
@get_band_width = (plot, scale_name) ->
    pixels = d3.extent(plot.scale_ranges[scale_name])[1]
    number_of_bands = plot.scales[scale_name].domain().length
    band_width = pixels / number_of_bands
    band_width

# n = 3, [-1,0,1]
# n = 4, [-1.5,-.5,.5,1.5]
@get_band_indeces = (n) ->
    half_length = Math.floor(n/2)
    half_length = half_length - .5 if n %% 2 == 0
    indeces = [-half_length..half_length]
    indeces

plot.get_band_widths()
    .get_jitters()


# Create the blank plot
plot.center.append("defs").append("clipPath")
    .attr("id", "clip")
  .append("rect")
    .attr(
        "width": plot.width + 40
        "height": plot.height)

clip = plot.center.append("g")
    .attr("clip-path", "url(#clip)")

if plot.zoom
    clip.append("rect")
      .style("cursor": "move")
      .attr(
            "class": "overlay"
            "width":  plot.width
            "height": plot.height
            "fill": "none"
            "pointer-events": "all")
      .call(d3.behavior.zoom()
          .x(plot.scales.x)
          .y(plot.scales.y)
          .scaleExtent([1, Infinity])
          .on("zoom", () -> redraw() ))

    redraw = () ->
        plot.select(".x.axis").call(plot.axes.x);
        plot.select(".y.axis").call(plot.axes.y);
        g_points.attr("transform", transform_points)


# Create points
transform_points = (d) ->
    # don't confuse plot.jitters (d3-defined function)
    # with plot.jitter (user defined value)
    "translate(#{plot.scales.x(d.x) + plot.jitters.x(d.color_group)}, #{plot.scales.y(d.y) + plot.jitters.y(d.color_group)})"

g_points = clip.selectAll(".point")
    .data(plot.data)
  .enter().append("g")
    .attr(
          "class": "point"
          "transform": transform_points)

points = g_points.append("svg:circle")
    .attr(
        "r": (d) -> d.radius
        "id": (d,i) -> "point-#{i}"
        "fill": (d) -> color_scale(d.color_group)
        "stroke": "black"
        "stroke-width": stroke_width
        "opacity": (d,i) -> opacity
        "title": tooltip_content )
    .on('mouseover', (d, i) ->
        d3.select(this.parentNode).classed("hover", true)
        point = d3.select('circle#point-'+i)
        tip.show(point.datum(), point.node()))
    .on('mouseout',  (d, i) ->
        d3.select(this.parentNode).classed("hover", false)
        tip.hide())

# Create point names
point_names = g_points.append("text")
    .text((d) -> d.point_name)
    .attr(
        "dy": ".32em"
        "dx": (d) -> 8 + d.radius
        "text-anchor": "left"
        "opacity": (d,i) -> opacity
        "display": "none")
    .style(
        "fill": (d) -> color_scale(d.color_group)
        "font-size": "22px")
    .on('mouseover', (d, i) ->
        d3.select(this.parentNode).classed("hover", true)
        point = d3.select('circle#point-'+i)
        tip.show(point.datum(), point.node()))
    .on('mouseout',  (d, i) ->
        d3.select(this.parentNode).classed("hover", false)
        tip.hide())

# define big circle overlays to make points easier to select
# overlay_radius = 7
# clip.selectAll("circle.overlay")
#     .data(plot.data)
#   .enter().append("svg:circle")
#     .attr(
#         "class": "overlay"
#         "cx": (d) -> plot.scales.x(d.x)
#         "cy": (d) -> plot.scales.y(d.y)
#         "fill-opacity": 0
#         "r": (d) -> d3.max([overlay_radius, d.radius]))



# Create tip
tip = d3.tip()
    .attr('class', 'd3-tip')
    .offset([-15, 0])
    .html(tooltip_content)

clip.call(tip);

# Sidebar
if show_sidebar
    sidebar = plot.right_region.append("g")
        .attr("transform","translate(60,0)")

    g_toggle_names = sidebar.append("g")
        .style("cursor", "pointer")
        .attr("class", "hideable")
        .attr("id", "show_names")
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
        point_names.attr("display", ()-> if showing_names then "none" else "inline")
        g_toggle_names.classed("show_names", !showing_names)
            .select("circle").attr("fill", ()-> if showing_names then "white" else "black")

    # Draw color legend only when there is more than one color
    if color_scale.range().length > 1
        g_color_title = sidebar.append("text")
            .attr("class", "hideable")
            .attr(
                  "x": -5
                  "y": distance_between_show_names_and_color_groups
                  "dy": ".35em") # Show one / Show all

        g_color_title.append("tspan")
            .style(
                  "font-size": "16px"
                  "font-weight": "bold")
            .text(plot.labels.color_title)

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
            .data(color_scale.domain())
          .enter().append("g")
            .attr(
                  "transform": (d, i) -> "translate(0, #{i * (5 * 2 + 15) + distance_between_show_names_and_color_groups + 30})"
                  "class": "color_group_key")
            .style("cursor", "pointer")

        g_color_group_keys.append("circle")
            .attr(
                "r": static_radius
                "fill": color_scale)
            .on("click", (d)-> toggle_points(d))

        g_color_group_keys.append("text")
            .attr(
                "x": 5 + 10
                "y": 0
                "dy": ".35em")
            .text((d) -> "#{d} (#{color_legend_counts[d]})")
            .on("click", (d)-> toggle_points(d))

# Aux functions
show_all_colors = () ->
    g_points.classed("hide", false)
    g_color_group_keys.classed("hide", false)
    single_group.text("Show one")

toggle_points = (color_groups)->
    # if the elements with the color_groups were hidden, then show; if not hidden, hide.
    g_points.filter((d)-> d.color_group == color_groups).classed("hide", ()->
        !d3.select(this).classed("hide")
    )

    g_color_group_keys.filter((d)-> d == color_groups).classed("hide", ()->
        !d3.select(this).classed("hide")
    )

    color_groups = g_points.filter(":not(.hide)").data().map((d)-> d.color_group).unique()


    if color_groups.length == 0
        show_all_colors()
    else if color_groups.length == 1
        single_group.text("Show all")
    else
        single_group.text("Show one")


deselect_color_groups = ()->
    visible_points = g_points.filter(":not(.hide)")
    color_groups = visible_points.data().map((d)-> d.color_group).unique()
    if single_group.text() == "Show one"
        visible_color_groups = color_groups.reverse()[0]

        g_points.filter((d)-> d.color_group != visible_color_groups).classed("hide", true)
        g_color_group_keys.filter((d)-> d != visible_color_groups).classed("hide", true)
        single_group.text("Show all")
    else
        show_all_colors()

d3.select(window).on("keydown", () ->
    switch d3.event.keyCode
      when 72 # "h"
        d3.selectAll(".hideable").classed("hidden", (d,i) -> !d3.select(this).classed("hidden"))
)

#     # console.log(d3.event.keyCode)
#     if (d3.event.keyCode in [78, 32]) # 'n' or 'space bar'
#         change()

# search bar
# TODO: replace this with an svg input form
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
            g_points.classed("hide", false)

        g_points.classed("g-match", (d)->
            re.test(d.point_name)
        )

        matches = d3.selectAll(".g-match")

        if (matches[0].length == 1)
            mouseover(matches)
        else
            mouseout()

        search_clear.style("display", null)

    else
        mouseout()
        clip.classed("g-searching", false)
        g_points.classed("g-match", false)
        search_clear.style("display", "none")

mouseover = (d) ->
    tip.show(d.datum(), d.node())

mouseout = () ->
    tip.hide()

search_input = d3.select(".g-search input")
    .on("keyup", () -> 
        keyuped.apply(this)
        d3.event.preventDefault()
    ).on("keydown", () -> d3.event.stopPropagation()) # to allow hideable

search_clear = d3.select(".g-search .g-search-clear")
    .on("click", () ->
        search_input.property("value", "")
        search()
    )