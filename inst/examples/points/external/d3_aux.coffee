@my_light_red = "#b90000"

@append_main = (opts = {}) ->
    opts.element ?= "svg:svg"
    opts.selector ?= "body"
    opts.background ?= "#fff"
    opts.width ?= 200
    opts.height ?= 200
    opts.margin ?= 10
    opts.class ?= "main"

    main = d3.select(opts.selector)
        .append(opts.element)
        .attr("width", opts.width)
        .attr("height", opts.height)
        .attr("class", opts.class)
        .style("background", opts.background)
        .style("margin", opts.margin)

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

# Generate two linear scales (x,y) when providing a width and a height
@get_scales = (width, height) ->
    scales = {}
    scales.x = d3.scale.linear()
        .domain([0, width])
        .range([0, width])

    scales.y = d3.scale.linear()
        .domain([0, height])
        .range([height,0])

    scales

@append_plot = (opts = {}) ->
    opts.margin ?=
        top: 20
        right: 150
        bottom: 30
        left: 50

    opts.width ?= 400
    opts.height ?= 400
    opts.background ?= "#fff"
    opts.class ?= "plot"

    opts.total_margin = d3.max([opts.margin.left + opts.margin.right, opts.margin.top + opts.margin.bottom])
    opts.width = opts.width - opts.total_margin
    opts.height = opts.height - opts.total_margin

    # TODO: refactor opts_for_main so you don't have to duplicate properties
    plot = append_main(
        background: opts.background
        id: opts.id
        width: opts.width + opts.total_margin
        height: opts.height + opts.total_margin
        margin: 20
    )

    plot = plot.append("svg:g")
        .attr("class", opts.class)
        .attr("transform", "translate(#{opts.margin.left},#{opts.margin.top})")

    plot.scales = get_scales(opts.width, opts.height)

    plot.margin = opts.margin
    plot.width = opts.width
    plot.height = opts.height

    plot

@draw_axes = (plot, opts = {}) ->
    opts.orientation_x ?= "bottom"
    opts.orientation_y ?= "left"

    plot.axes = {}
    plot.axes.x = d3.svg.axis()
        .scale(plot.scales.x)
        .orient(opts.orientation_x)
        .tickSize(6,0)

    plot.axes.y = d3.svg.axis()
        .scale(plot.scales.y)
        .orient(opts.orientation_y)
        .tickSize(6,0)

    x_axis = plot.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, #{plot.height})")
        .call(plot.axes.x)

    plot.append("g")
        .attr("class", "y axis")
        .call(plot.axes.y)

    plot


@parent_of = (child)->
    d3.select(child).node().parentNode

@add_scale_padding = (scale, padding = 20) ->
    range = scale.range()
    if (range[0] > range[1])
        padding *= -1

    # To increase the range by padding, you need to find the domain that will give you this modified range (to do that, you use scale.invert), also, try .nice()
    scale.domain( [range[0] - padding, range[1] + padding].map(scale.invert) )

