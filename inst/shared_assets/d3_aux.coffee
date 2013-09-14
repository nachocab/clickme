my_light_red = "#b90000"

@append_main = (opts = {}) ->
    opts.element ?= "svg:svg"
    opts.selector ?= "body"
    opts.background ?= "#fff"
    opts.width ?= 200
    opts.height ?= 200
    opts.padding ?= 10

    main = d3.select(opts.selector)
        .append(opts.element)
        # .attr({
        #     "width": "100%"
        #     "height": "100%"
        #     "viewBox": "0 0 #{opts.width} #{opts.height}"
        # })
        .attr({
            "width": opts.width
            "height": opts.height
        }).style({
            'background': opts.background
            'padding': opts.padding
        })

    if (opts.id)
        main.attr("id", opts.id)

    if (opts.class)
        main.attr("class", opts.class)

    main.width = opts.width
    main.height = opts.height
    main.svg = opts.selector

    main

# calculates padding, appends the svg + g, draws the title
@new_plot = (opts = {}) ->
    opts.padding ?=
        top: 20
        right: 150
        bottom: 30
        left: 50
    opts.total_padding = d3.max([opts.padding.left + opts.padding.right, opts.padding.top + opts.padding.bottom])

    opts.width ?= 400
    opts.height ?= 400
    opts.total_height = opts.height + opts.padding.top + opts.padding.bottom
    opts.total_width = opts.width + opts.padding.left + opts.padding.right

    opts.background ?= "#fff"
    opts.zoom ?= true
    opts.ordinal_scale_padding ?= 1
    opts.linear_scale_padding ?= 40

    opts.rotate_label.y ?= true

    plot = append_main(
            id: opts.id
            width: opts.total_width
            height: opts.total_height
            background: opts.background
            padding: 0
        ).append("svg:g")
            # .attr("transform", "translate(#{opts.padding.left},#{opts.padding.top})")

    # move all the opts elements to plot
    for key, value of opts
        plot[key] = value

    plot.top_margin = plot.append("g")
        .attr("transform", "translate(#{plot.padding.left}, 0)")
        .attr("class", "top")

    plot.right_margin = plot.append("g")
        .attr("transform", "translate(#{plot.padding.left + plot.width}, #{plot.padding.top})")
        .attr("class", "right")

    plot.bottom_margin = plot.append("g")
        .attr("transform", "translate(#{plot.padding.left}, #{plot.padding.top + plot.height})")
        .attr("class", "bottom")

    plot.left_margin = plot.append("g")
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

    plot.get_scale_limits = () ->
        plot.scale_limits = {}
        plot.scale_limits.x = plot.xlim
        plot.scale_limits.y = plot.ylim

    plot.get_scale_domains = ()->
        plot.scale_domains = {}
        plot.scale_domains.x = get_scale_domain(plot, "x")
        plot.scale_domains.y = get_scale_domain(plot, "y")

    plot.get_scale_ranges = () ->
        plot.scale_ranges = {}
        plot.scale_ranges.x = [0, plot.width]
        plot.scale_ranges.y = [plot.height, 0]

    plot.get_scales = ()->
        plot.get_scale_types()
        plot.get_scale_limits()
        plot.get_scale_domains()
        plot.get_scale_ranges()

        plot.scales = {}
        plot.scales.x = get_scale(plot, "x")
        plot.scales.y = get_scale(plot, "y")

    plot.get_jitters = ()->
        plot.jitters = {}
        plot.jitters.x = get_jitter(plot, "x")
        plot.jitters.y = get_jitter(plot, "y")

    plot.add_title = () ->
        plot.top_margin.append("text")
            .text(plot.title)
            .attr(
                "class": "title"
                "text-anchor": "middle"
                "x": plot.width / 2
                "y": plot.padding.top / 2
            )

        plot

    plot.add_subtitle = () ->
        plot.top_margin.append("text")
            .text(plot.subtitle)
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

        plot.bottom_margin.append("g")
            .attr("class", "x axis")
            .call(plot.axes.x)

        plot.bottom_margin.selectAll(".x.axis line, .x.axis path")
            .style(
                "fill": "none"
                "stroke": "black"
                "shape-rendering": "crispEdges"
                "stroke-width": 2
            )

        plot.add_x_axis_label(plot.xlab)

        plot

    plot.add_y_axis = () ->
        plot.orientation_y ?= "left"

        plot.axes.y = d3.svg.axis()
            .scale(plot.scales.y)
            .orient(plot.orientation_y)

        plot.left_margin.append("g")
            .attr("class", "y axis")
            .call(plot.axes.y)

        plot.left_margin.selectAll(".y.axis line, .y.axis path")
            .style(
                "fill": "none"
                "stroke": "black"
                "shape-rendering": "crispEdges"
                "stroke-width": 2
            )

        plot.add_y_axis_label(plot.ylab)

        plot

    plot.add_x_axis_label = (text) ->
        plot.bottom_margin.append("text")
            .text(text)
            .attr(
                "class": "x label"
                "text-anchor": "middle"
                "x": plot.width/2
                "y": plot.padding.bottom - 5
            )

        plot

    plot.add_y_axis_label = (text) ->
        label = plot.left_margin.append("text")
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
    plot.add_subtitle()

    plot.get_scales()
    if plot.scale_types.x is "ordinal" or plot.scale_types.y is "ordinal"
        plot.zoom = false

    plot.get_jitters()

    plot.add_axes()

    plot


@get_scale_type = (plot, scale_name) ->
    if type(plot.data_ranges[scale_name][0]) is "number"
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
            .rangePoints(plot.scale_ranges[scale_name], plot.ordinal_scale_padding)

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

@type = (obj) ->
  if obj == undefined or obj == null
    return String obj
  classToType = new Object
  for name in "Boolean Number String Function Array Date RegExp".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  myClass = Object.prototype.toString.call obj
  if myClass of classToType
    return classToType[myClass]
  return "object"

@append_container = (opts = {})->
    opts.selector ?= "body"
    opts.class ?= "container"

    container = d3.select(opts.selector)
        .append('div')
        .attr("class", opts.class)
        .style("overflow", "hidden")

    container

@append_div = (container, opts = {})->
    opts.background ?= my_light_red
    opts.margin ?= 10

    div = d3.select(container.node())
        .append('div')
        .style('background', opts.background)
        .style('margin', opts.margin)
        .style("float", "left")

    if (opts.id)
        div.attr("id", opts.id)

    if (opts.class)
        div.attr("class", opts.class)

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
