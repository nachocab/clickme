my_light_red = "#b90000"

# Helper function to create the outer SVG
@append_outer_svg = (options = {}) ->
    options.element ?= "svg:svg"
    options.selector ?= "body"
    options.background ?= "#fff"
    options.width ?= 200
    options.height ?= 200
    options.padding ?= 10

    main = d3.select(options.selector)
        .append(options.element)
        .attr({
            "width": options.width
            "height": options.height
        }).style({
            'background': options.background
            'padding': options.padding
        })

    if (options.id)
        main.attr("id", options.id)

    if (options.class)
        main.attr("class", options.class)

    main.width = options.width
    main.height = options.height
    main.svg = options.selector

    main

# Helper function that builds the components of the plot. It handles:
# - dimensions of the outer svg + g
# - padding
# - regions
#       - top (title)
#       - bottom (bottom axis)
#       - left (left axis)
#       - center (the actual plot)
#       - right (sidebar)
# - scales
#       - type (linear, ordinal)
#       - domain (quantitative, categorical)
#       - range (xlim, ylim)
#       - jitter
# - axes (ticks)
# - labels (title, subtitle, x, y, rotation angles)
# - background color
# - zoom
@new_plot = (options = {}) ->

    # data is an array that has at least one object with x and y fields
    options.data ?= [x: 0, y: 0]

    # This only works with if data.x is an array
    # TODO: make an explicit check that data has x and y (otherwise fail)
    options.data_ranges ?= {}
    options.data_ranges.x ?= [d3.min(options.data.x), d3.max(options.data.x)]
    options.data_ranges.y ?= [d3.min(options.data.y), d3.max(options.data.y)]

    options.padding ?= {}
    options.padding.top ?= 20
    options.padding.right ?=150
    options.padding.bottom ?= 30
    options.padding.left ?= 50

    options.width ?= 400
    options.height ?= 400
    options.total_height = options.height + options.padding.top + options.padding.bottom
    options.total_width = options.width + options.padding.left + options.padding.right

    options.background ?= "#fff"
    options.zoom ?= true
    options.categorical_scale_padding ?= 1
    options.linear_scale_padding ?= 40

    options.labels ?= {}
    options.labels.title ?= ""
    options.labels.x ?= "x"
    options.labels.y ?= "y"

    options.rotate_label ?= {}
    options.rotate_label.x ?= false
    options.rotate_label.y ?= true

    options.scale_limits ?= {}
    options.scale_limits.x ?= null
    options.scale_limits.y ?= null

    plot = append_outer_svg(
            id: options.id
            width: options.total_width
            height: options.total_height
            background: options.background
            padding: 0
        ).append("svg:g")
            # .attr("transform", "translate(#{options.padding.left},#{options.padding.top})")

    # move all the options elements to plot
    for key, value of options
        plot[key] = value

    # append regions
    plot.top_region = plot.append("g")
        .attr("transform", "translate(#{plot.padding.left}, 0)")
        .attr("class", "top")

    plot.right_region = plot.append("g")
        .attr("transform", "translate(#{plot.padding.left + plot.width}, #{plot.padding.top})")
        .attr("class", "right")

    plot.bottom_region = plot.append("g")
        .attr("transform", "translate(#{plot.padding.left}, #{plot.padding.top + plot.height})")
        .attr("class", "bottom")

    plot.left_region = plot.append("g")
        .attr("transform", "translate(#{plot.padding.left}, #{plot.padding.top})")
        .attr("class", "left")

    plot.center = plot.append("g")
        .attr("transform", "translate(#{plot.padding.left}, #{plot.padding.top})")
        .attr("class", "center")

    plot.get_scale_types = ()->
        plot.scale_types = {}
        # TODO: check if plot.log == "x"
        plot.scale_types.x = get_scale_type(plot, "x")
        plot.scale_types.y = get_scale_type(plot, "y")
        plot

    plot.get_scale_domains = ()->
        plot.scale_domains = {}
        plot.scale_domains.x = get_scale_domain(plot, "x")
        plot.scale_domains.y = get_scale_domain(plot, "y")
        plot

    plot.get_scale_ranges = () ->
        plot.scale_ranges = {}
        plot.scale_ranges.x = [0, plot.width]
        plot.scale_ranges.y = [plot.height, 0]
        plot

    plot.get_scales = ()->
        plot.get_scale_types()
            .get_scale_domains()
            .get_scale_ranges()

        plot.scales = {}
        plot.scales.x = get_scale(plot, "x")
        plot.scales.y = get_scale(plot, "y")
        plot

    plot.get_jitters = ()->
        plot.jitters = {}
        plot.jitters.x = get_jitter(plot, "x")
        plot.jitters.y = get_jitter(plot, "y")
        plot

    plot.add_title = () ->
        plot.top_region.append("text")
            .text(plot.labels.title)
            .attr(
                "class": "title"
                "text-anchor": "middle"
                "x": plot.width / 2
                "y": plot.padding.top / 2
            )

        plot

    plot.add_subtitle = () ->
        plot.top_region.append("text")
            .text(plot.labels.subtitle)
            .attr(
                "class": "subtitle"
                "text-anchor": "middle"
                "x": plot.width / 2
                "y": plot.padding.top / 2 + 30
            )
        plot

    plot.add_axes = () ->
        plot.axes = {}
        plot.add_x_axis()
        plot.add_y_axis()
        plot

    plot.add_x_axis = () ->
        plot.orientation_x ?= "bottom"

        plot.axes.x = d3.svg.axis()
            .scale(plot.scales.x)
            .orient(plot.orientation_x)

        if plot.hide_x_tick_labels is true
            plot.axes.x.tickFormat("")

        # if tick_values?
            # plot.axes.x.tickValues(tick_values)

        plot.bottom_region.append("g")
            .attr("class", "x axis")
            .call(plot.axes.x)

        plot.bottom_region.selectAll(".x.axis line, .x.axis path")
            .style(
                "fill": "none"
                "stroke": "black"
                "shape-rendering": "crispEdges"
                "stroke-width": 2
            )

        plot.add_x_axis_label(plot.labels.x)
        plot

    plot.add_y_axis = () ->
        plot.orientation_y ?= "left"

        plot.axes.y = d3.svg.axis()
            .scale(plot.scales.y)
            .orient(plot.orientation_y)

        plot.left_region.append("g")
            .attr("class", "y axis")
            .call(plot.axes.y)

        plot.left_region.selectAll(".y.axis line, .y.axis path")
            .style(
                "fill": "none"
                "stroke": "black"
                "shape-rendering": "crispEdges"
                "stroke-width": 2
            )

        plot.add_y_axis_label(plot.labels.y)
        plot

    plot.add_x_axis_label = (text) ->
        plot.bottom_region.append("text")
            .text(text)
            .attr(
                "class": "x label"
                "text-anchor": "middle"
                "x": plot.width/2
                "y": plot.padding.bottom - 5
            )
        plot

    plot.add_y_axis_label = (text) ->
        label = plot.left_region.append("text")
            .text(text)
            .attr(
                "class": "y label"
                "text-anchor": "middle"
                "x": -plot.height/2)

        if plot.rotate_label.y is true
            label.attr(
                       "y": -plot.padding.left + 5
                       "dy": "1em"
                       "transform": "rotate(-90)")
        else
            label.attr(
                       "dx": "1em"
                       "y": plot.padding.left - 5)

        plot

    plot.add_title()
        .add_subtitle()
        .get_scales()

    if plot.scale_types.x is "ordinal" or plot.scale_types.y is "ordinal"
        plot.zoom = false

    plot.get_jitters()
        .add_axes()

    plot

# aux functions
@get_scale_type = (plot, scale_name) ->
    # we can't check plot.data because it doesn't always have a scale_name
    if get_type(plot.data_ranges[scale_name][0]) is "number"
        # TODO: check if plot.log == scale_name and return scale_type = "log"
        scale_type = "linear"
    else
        scale_type = "ordinal"

    scale_type

@get_scale_domain = (plot, scale_name)->
    if plot.scale_types[scale_name] is "linear"
        if plot.scale_limits[scale_name]?
            domain = plot.scale_limits[scale_name]
        else
            domain = plot.data_ranges[scale_name]
    else
        domain = plot.categorical_domains[scale_name]

    domain


@get_scale = (plot, scale_name)->
    if plot.scale_types[scale_name] is "linear"
        scale = d3.scale.linear()
            .domain(plot.scale_domains[scale_name])
            .range(plot.scale_ranges[scale_name])
        scale = add_scale_padding(scale, plot.linear_scale_padding)
    else
        scale = d3.scale.ordinal()
            .domain(plot.scale_domains[scale_name])
            .rangePoints(plot.scale_ranges[scale_name], plot.categorical_scale_padding)

    scale

@get_jitter = (plot, scale_name) ->
    if plot.scale_types[scale_name] is "ordinal"
        band_width = (d3.extent(plot.scale_ranges[scale_name])[1] / plot.scales[scale_name].domain().length)
        jitter = ()-> band_width * plot.jitter * random()
    else
        jitter = ()-> 0

    jitter

@add_scale_padding = (scale, padding) ->
    range = scale.range()
    if (range[0] > range[1])
        padding *= -1

    # To increase the range by padding, you need to find the domain that will give you this modified range (to do that, you use scale.invert)
    domain_with_padding = [range[0] - padding, range[1] + padding].map(scale.invert)
    scale.domain(domain_with_padding)

    scale

@random = () ->
    (Math.random() * 2) - 1

@parent_of = (child)->
    d3.select(child).node().parentNode

@format_property = (x) ->
    decimal_format = d3.format(".2f")

    if type(x) == "number" && x % 1 != 0
        decimal_format(x)
    else
        x

@get_type = (obj) ->
  if obj == undefined or obj == null
    return String obj
  classToType = new Object
  for name in "Boolean Number String Function Array Date RegExp".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  myClass = Object.prototype.toString.call obj
  if myClass of classToType
    return classToType[myClass]
  return "object"

@append_container = (options = {})->
    options.selector ?= "body"
    options.class ?= "container"

    container = d3.select(options.selector)
        .append('div')
        .attr("class", options.class)
        .style("overflow", "hidden")

    container

@append_div = (container, options = {})->
    options.background ?= my_light_red
    options.margin ?= 10

    div = d3.select(container.node())
        .append('div')
        .style('background', options.background)
        .style('margin', options.margin)
        .style("float", "left")

    if (options.id)
        div.attr("id", options.id)

    if (options.class)
        div.attr("class", options.class)

    div

Array::unique = ->
    o = {}
    l = @length
    r = []
    i = 0
    while i < l
        o[this[i]] = this[i]
        i += 1
    for i of o
        r.push o[i]
    r
