# function to create background, axes, and axis labels
plotframe = (data, args=null, svgscale={svg:null, x:null, y:null}) ->
  # default name to place chart
  chartname = args?.chartname ? "body"

  # create SVG object if necessary
  if svgscale.svg is null
    height = args?.height ? 500
    width = args?.width ? 800
    svgscale.svg = d3.select(chartname)
      .append("svg")
      .attr("height", height)
      .attr("width", width)

  # padding
  pad = args?.pad ? {bottom: 50, left: 50, top: 3, right: 3}
  scalePadding = args?.scalePadding ? 0.05

  # make background rectangle
  svgscale.svg.append("rect")
    .attr("id", "bgrect")
    .attr("x", pad.left)
    .attr("y", pad.top)
    .attr("width", width-(pad.left+pad.right))
    .attr("height", height-(pad.top+pad.bottom))

  # names of X and Y variables
  x_name = args?.x_name ? "x"
  y_name = args?.y_name ? "y"

  # X and Y min and max
  x_min = args?.x_min ? d3.min data, (d) -> d[x_name]
  x_max = args?.x_max ? d3.max data, (d) -> d[x_name]
  y_min = args?.y_min ? d3.min data, (d) -> d[y_name]
  y_max = args?.y_max ? d3.max data, (d) -> d[y_name]

  x_min -= (x_max-x_min)*scalePadding
  x_max += (x_max-x_min)*scalePadding
  y_min -= (y_max-y_min)*scalePadding
  y_max += (y_max-y_min)*scalePadding

  # create X and Y scales if necessary
  if svgscale.x is null
    svgscale.x = d3.scale.linear()
      .domain([x_min, x_max])
      .range([pad.left, width-pad.right])
  if svgscale.y is null
    svgscale.y = d3.scale.linear()
      .domain([y_min, y_max])
      .range([height-pad.bottom, pad.top])

  # numbers of ticks
  num_x_ticks = args?.num_x_ticks ? 6
  num_y_ticks = args?.num_y_ticks ? 6

  tickPadding = args?.tickPadding ? 3

  x_axis = d3.svg.axis().scale(svgscale.x).orient("bottom").ticks(num_x_ticks).tickSize(0,0,0).tickPadding(tickPadding);
  y_axis = d3.svg.axis().scale(svgscale.y).orient("left").ticks(num_y_ticks).tickSize(0,0,0).tickPadding(tickPadding);

  x_ticks = svgscale.x.ticks(num_x_ticks)
  y_ticks = svgscale.y.ticks(num_y_ticks)

  # vertical and horizontal lines
  svgscale.svg.selectAll("#verline")
      .data(x_ticks)
      .enter()
      .append("line")
      .attr("x1", (d) -> svgscale.x(d))
      .attr("x2", (d) -> svgscale.x(d))
      .attr("id", "verline")
      .attr("fill", "none")
      .attr("stroke", "white")
      .attr("y1", pad.top)
      .attr("y2", height-pad.bottom)

  svgscale.svg.selectAll("#horline")
      .data(y_ticks)
      .enter()
      .append("line")
      .attr("y1", (d) -> svgscale.y(d))
      .attr("y2", (d) -> svgscale.y(d))
      .attr("id", "horline")
      .attr("fill", "none")
      .attr("stroke", "white")
      .attr("x1", pad.left)
      .attr("x2", width-pad.right)

  # x and y axis numbers
  svgscale.svg.append("g")
       .attr("class", "axis")
       .attr("transform", "translate(0, #{height - pad.bottom})")
       .call(x_axis)

  svgscale.svg.append("g")
       .attr("class", "axis")
       .attr("transform", "translate(#{pad.left}, 0)")
       .call(y_axis)

  # x and y axis labels
  xlab = args?.xlab ? x_name
  ylab = args?.ylab ? y_name
  ylab_rotate = args?.ylab_rotate ? 270

  svgscale.svg.append("text")
     .attr("x", (pad.left + width - pad.right)/2)
     .attr("y", height-pad.bottom/4)
     .attr("class", "axislabel")
     .style("font-family", "sans-serif")
     .text(xlab)

  if ylab_rotate
    rotation = "rotate( #{ylab_rotate} #{pad.left/4} #{(pad.top+height-pad.bottom)/2})"
  else
    rotation = "rotate(0 0 0)"

  ylabel = svgscale.svg.append("text")
     .attr("x", pad.left/4)
     .attr("y", (pad.top + height - pad.bottom)/2)
     .attr("class", "axislabel")
     .style("font-family", "sans-serif")
     .attr("transform", rotation)
     .text(ylab)

  svgscale
