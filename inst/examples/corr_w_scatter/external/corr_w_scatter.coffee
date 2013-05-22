# corr_w_scatter.coffee
#
# Left panel is a heat map of a correlation matrix; hover over pixels
# to see the values; click to see the corresponding scatterplot on the right

d3.json "data.json", (data) ->

  # dimensions of SVG
  h = 450
  w = h
  pad = {left:70, top:40, right:5, bottom: 70}
  innerPad = 5
  circleRadius = 2

  totalh = h + pad.top + pad.bottom
  totalw = (w + pad.left + pad.right)*2

  svg = d3.select("div#plot")
          .append("svg")
          .attr("height", totalh)
          .attr("width", totalw)

  # panel for correlation image
  corrplot = svg.append("g")
               .attr("id", "corrplot")
               .attr("transform", "translate(#{pad.left},#{pad.top})")

  # panel for scatterplot
  scatterplot = svg.append("g")
                   .attr("id", "scatterplot")
                   .attr("transform", "translate(#{pad.left*2+pad.right+w},#{pad.top})")

  # no. data points
  nind = data.ind.length
  nvar = data.var.length

  corXscale = d3.scale.ordinal().domain(d3.range(nvar)).rangeBands([0, w])
  corYscale = d3.scale.ordinal().domain(d3.range(nvar)).rangeBands([h, 0])
  corZscale = d3.scale.linear().domain([-1, 0, 1]).range(["darkslateblue", "white", "crimson"])

  # create list with correlations
  corr = []
  for i of data.corr
    for j of data.corr[i]
      corr.push({row:i, col:j, value:data.corr[i][j]})


  # function to determine rounding of axis labels
  formatAxis = (d) ->
    d = d[1] - d[0]
    ndig = Math.floor( Math.log(d % 10) / Math.log(10) )
    ndig = 0 if ndig > 0
    ndig = Math.abs(ndig)
    d3.format(".#{ndig}f")

  # gray background on scatterplot
  scatterplot.append("rect")
             .attr("height", h)
             .attr("width", w)
             .attr("fill", d3.rgb(200, 200, 200))
             .attr("stroke", "black")
             .attr("stroke-width", 1)
             .attr("pointer-events", "none")

  cells = corrplot.selectAll("empty")
             .data(corr)
             .enter().append("rect")
             .attr("class", "cell")
             .attr("x", (d) -> corXscale(d.col))
             .attr("y", (d) -> corYscale(d.row))
             .attr("width", corXscale.rangeBand())
             .attr("height", corYscale.rangeBand())
             .attr("fill", (d) -> corZscale(d.value))
             .attr("stroke", "none")
             .attr("stroke-width", 2)
             .on("mouseover", (d) ->
                 d3.select(this).attr("stroke", "black")
                 corrplot.append("text").attr("id", "corrtext")
                         .text(d3.format(".2f")(d.value))
                         .attr("x", ->
                             mult = -1
                             mult = +1 if d.col < nvar/2
                             corXscale(d.col) + mult * 30)
                         .attr("y", ->
                             mult = +1
                             mult = -1 if d.row < nvar/2
                             corYscale(d.row) + (mult + 0.35) * 20)
                         .attr("fill", "black")
                         .attr("dominant-baseline", "middle")
                         .attr("text-anchor", "middle")
                 corrplot.append("text").attr("class","corrlabel")
                         .attr("x", corXscale(d.col))
                         .attr("y", h+pad.bottom*0.2)
                         .text(data.var[d.col])
                         .attr("dominant-baseline", "middle")
                         .attr("text-anchor", "middle")
                 corrplot.append("text").attr("class","corrlabel")
                         .attr("y", corYscale(d.row))
                         .attr("x", -pad.left*0.1)
                         .text(data.var[d.row])
                         .attr("dominant-baseline", "middle")
                         .attr("text-anchor", "end"))
             .on("mouseout", ->
                 d3.selectAll("text.corrlabel").remove()
                 d3.selectAll("text#corrtext").remove()
                 d3.select(this).attr("stroke","none"))
             .on("click",(d) -> drawScatter(d.col, d.row))

  # colors for scatterplot
  nGroup = d3.max(data.group)
  if nGroup == 1
    colors = [ d3.rgb(150, 150, 150) ]
  else if nGroup <= 3
    colors = ["crimson", "green", "darkslateblue"]
  else 
    if nGroup <= 10
      colorScale = d3.scale.category10()
    else
      colorScale = d3.scale.category20()
    colors = (colorScale(i) for i of d3.range(nGroup))

  drawScatter = (i,j) ->
    d3.selectAll("circle.points").remove()
    d3.selectAll("text.axes").remove()
    d3.selectAll("line.axes").remove()

    # points that have no missing values
    x = []
    y = []
    z = []
    for d in d3.range(nind)
      if data.dat[i][d] != "NA" and data.dat[j][d] != "NA"
        x.push(data.dat[i][d])
        y.push(data.dat[j][d])
        z.push(data.group[d])
    return null if x.length == 0 

    xScale = d3.scale.linear()
                     .domain(d3.extent(x))
                     .range([innerPad, w-innerPad])
    yScale = d3.scale.linear()
                     .domain(d3.extent(y))
                     .range([h-innerPad, innerPad])
    # axis labels
    scatterplot.append("text")
               .attr("id", "xaxis")
               .attr("class", "axes")
               .attr("x", w/2)
               .attr("y", h+pad.bottom*0.7)
               .text(data.var[i])
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "middle")
               .attr("fill", "slateblue")
    scatterplot.append("text")
               .attr("id", "yaxis")
               .attr("class", "axes")
               .attr("x", -pad.left*0.8)
               .attr("y", h/2)
               .text(data.var[j])
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "middle")
               .attr("transform", "rotate(270,#{-pad.left*0.8},#{h/2})")
               .attr("fill", "slateblue")
    # axis scales
    xticks = xScale.ticks(5)
    yticks = yScale.ticks(5)
    scatterplot.selectAll("empty")
               .data(xticks)
               .enter()
               .append("text")
               .attr("class", "axes")
               .text((d) -> formatAxis(xticks)(d))
               .attr("x", (d) -> xScale(d))
               .attr("y", h+pad.bottom*0.3)
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "middle")
    scatterplot.selectAll("empty")
               .data(yticks)
               .enter()
               .append("text")
               .attr("class", "axes")
               .text((d) -> formatAxis(yticks)(d))
               .attr("x", -pad.left*0.1)
               .attr("y", (d) -> yScale(d))
               .attr("dominant-baseline", "middle")
               .attr("text-anchor", "end")
    scatterplot.selectAll("empty")
               .data(xticks)
               .enter()
               .append("line")
               .attr("class", "axes")
               .attr("x1", (d) -> xScale(d))
               .attr("x2", (d) -> xScale(d))
               .attr("y1", 0)
               .attr("y2", h)
               .attr("stroke", "white")
               .attr("stroke-width", 1)
    scatterplot.selectAll("empty")
               .data(yticks)
               .enter()
               .append("line")
               .attr("class", "axes")
               .attr("y1", (d) -> yScale(d))
               .attr("y2", (d) -> yScale(d))
               .attr("x1", 0)
               .attr("x2", w)
               .attr("stroke", "white")
               .attr("stroke-width", 1)

    # the points
    scatterplot.selectAll("empty")
               .data(x)
               .enter()
               .append("circle")
               .attr("class", "points")
               .attr("cx", (d,i) -> xScale(x[i]))
               .attr("cy", (d,i) -> yScale(y[i]))
               .attr("r", circleRadius)
               .attr("stroke", "black")
               .attr("stroke-width", 1)
               .attr("fill", (d,i) -> colors[z[i]-1])

  # boxes around panels
  corrplot.append("rect")
         .attr("height", h)
         .attr("width", w)
         .attr("fill", "none")
         .attr("stroke", "black")
         .attr("stroke-width", 1)
         .attr("pointer-events", "none")

  scatterplot.append("rect")
             .attr("height", h)
             .attr("width", w)
             .attr("fill", "none")
             .attr("stroke", "black")
             .attr("stroke-width", 1)
             .attr("pointer-events", "none")

  # text above
  corrplot.append("text")
          .text("Correlation matrix")
          .attr("id", "corrtitle")
          .attr("x", w/2)
          .attr("y", -pad.top/2)
          .attr("dominant-baseline", "middle")
          .attr("text-anchor", "middle")

  scatterplot.append("text")
             .text("Scatterplot")
             .attr("id", "corrtitle")
             .attr("x", w/2)
             .attr("y", -pad.top/2)
             .attr("dominant-baseline", "middle")
             .attr("text-anchor", "middle")

  d3.select("div#legend")
    .style("opacity", 1)
