@my_light_red = "#b90000"

@append_main = (opts = {}) ->
    opts.element ?= "svg:svg"
    opts.selector ?= "body"
    opts.background ?= "#fff"
    opts.width ?= 200
    opts.height ?= 200
    opts.margin ?= 10

    main = d3.select(opts.selector)
        .append(opts.element)
        .attr({
            "width": "100%"
            "height": "100%"
            "viewBox": "0 0 #{opts.width} #{opts.height}"
        }).style({
            'background': opts.background
            'margin': opts.margin
        })

    if (opts.id)
        main.attr("id", opts.id)

    if (opts.class)
        main.attr("class", opts.class)

    main.width = opts.width
    main.height = opts.height
    main

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

@get_scales = (width, height) ->
    scales = {}
    scales.x = d3.scale.linear()
        .domain([0, width]) # you will likely have to redefine the domain
        .range([0, width])

    scales.y = d3.scale.linear()
        .domain([0, height]) # you will likely have to redefine the domain
        .range([height,0])

    scales

@append_plot = (opts = {}) ->
    opts.padding ?=
        top: 20
        right: 150
        bottom: 30
        left: 50

    opts.width ?= 400
    opts.height ?= 400
    opts.axis_padding ?= 20
    opts.background ?= "#fff"

    opts.x_domain ?= null
    opts.y_domain ?= null
    opts.title ?= ""
    opts.xlab ?= ""
    opts.ylab ?= ""

    opts.total_padding = d3.max([opts.padding.left + opts.padding.right, opts.padding.top + opts.padding.bottom])
    opts.width = opts.width - opts.total_padding
    opts.height = opts.height - opts.total_padding

    # TODO: refactor opts_for_main so you don't have to duplicate properties
    plot = append_main(
        background: opts.background
        id: opts.id
        width: opts.width + opts.total_padding
        height: opts.height + opts.total_padding
        margin: 20
    )

    plot = plot.append("svg:g")
        .attr("transform", "translate(#{opts.padding.left},#{opts.padding.top})")

    # somehow refactor this
    plot.padding = opts.padding
    plot.width = opts.width
    plot.height = opts.height
    plot.title = opts.title
    plot.xlab = opts.xlab
    plot.ylab = opts.ylab
    plot.selector = opts.selector

    plot.scales = get_scales(opts.width, opts.height)

    plot.scales.x.domain(opts.x_domain)
    plot.scales.x = add_scale_padding(plot.scales.x)

    plot.scales.y.domain(opts.y_domain)
    plot.scales.y = add_scale_padding(plot.scales.y)

    draw_axes(plot)
    draw_axes_labels(plot)

    plot

@draw_axes = (plot) ->
    plot.orientation_x ?= "bottom"
    plot.orientation_y ?= "left"

    plot.axes = {}
    plot.axes.x = d3.svg.axis()
        .scale(plot.scales.x)
        .orient(plot.orientation_x)

    plot.axes.y = d3.svg.axis()
        .scale(plot.scales.y)
        .orient(plot.orientation_y)

    plot.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0,#{plot.height})")
        .call(plot.axes.x)

    plot.append("g")
        .attr("class", "y axis")
        .call(plot.axes.y)

    plot.selectAll(".axis line, .axis path")
        .style(
            "fill": "none"
            "stroke": "black"
            "shape-rendering": "crispEdges"
            "stroke-width": 2
        )

    plot

@draw_axes_labels = (plot) ->
    plot.append("text")
        .text(plot.title)
        .attr(
            "class": "title"
            "text-anchor": "middle"
            "x": plot.width / 2
            "y": -plot.padding.top / 2
        )

    plot.append("text")
        .text(plot.xlab)
        .attr(
            "class": "x label"
            "text-anchor": "middle"
            "x": plot.width - plot.width/2
            "y": plot.height + plot.padding.bottom/2
            "dy": "2em"
        )

    plot.append("text")
        .text(plot.ylab)
        .attr(
            "class": "y label"
            "text-anchor": "middle"
            "x": 0 - (plot.height/2)
            "y": -plot.padding.left + 5
            "dy": "1em"
            "transform": "rotate(-90)"
        )

@parent_of = (child)->
    d3.select(child).node().parentNode

@add_scale_padding = (scale, padding = 20) ->
    range = scale.range()
    if (range[0] > range[1])
        padding *= -1

    # To increase the range by padding, you need to find the domain that will give you this modified range (to do that, you use scale.invert)
    scale.domain([range[0] - padding, range[1] + padding].map(scale.invert)).nice()

