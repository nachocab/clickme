class window.HeatmapView extends Backbone.View
    initialize: ->
        unless @model.options.hideHeatmap
            @render()

            # model changes that update the view
            @model.on "change:currentRowId", => @showCurrentRow() # mouseover/mouseout
            @model.on "change:clickedRowId", => @showClickedRow()
            @model.on "change:currentCluster", => @showCurrentCluster()
            @model.on "change:currentTag", => @showCurrentTag()

    events: ->
        # mouse events that change the model
        "mouseover .cell": "changeCurrentRowId"
        "mouseout .row": "changeCurrentRowId"
        "click .row": "changeClickedRowId"
        "click .tag": "changeCurrentTag"
        "click .tag_name": "changeCurrentTag"

    render: ->
        @heatmapColor = d3.scale.linear().domain([-1.5,0,1.5]).range(["#278DD6","#fff","#d62728"])
        @rowTextScaleFactor = 15
        @columnTextScaleFactor = 10
        @columnNamesMargin = d3.max(columnName.length for columnName in @model.columnNames)
        @rowNamesMargin = d3.max(rowName.length for rowName in @model.rowNames)
        @margin =
            top: 250 # this must account for longest column or tag name. TODO: calculate automatically
            right: @calculateRightMargin()
            bottom: 50
            left: 50
        @cellSize = 25
        @width = @cellSize*@model.columnNames.length
        @height = @cellSize*@model.rowNames.length


        @heatmap = d3.select(@el)
            .attr("width", @width + @margin.right + @margin.left)
            .attr("height", @height + @margin.top + @margin.bottom)
            .attr("class","heatmap")
          .append("g")
            .attr("transform", "translate(#{@margin.left},#{@margin.top})")

        @x = d3.scale.ordinal().domain(d3.range(@model.longitudinalData[0].length)).rangeBands([0, @width])
        @y = d3.scale.ordinal().domain(d3.range(@model.rowNames.length)).rangeBands([0, @height])

        @columns = @heatmap.selectAll(".column")
            .data(@model.columnNames)
          .enter().append("g")
            .attr("class", "column")

        # Add column names (top)
        @columns.append("text")
            .attr("x", 6)
            .attr("y", @x.rangeBand() / 2)
            .attr("dy", "-.5em") # .32em before rotating
            .attr("dx", ".5em")
            .attr("text-anchor", "start")
            .attr("transform", (d, i) => "translate(#{@x(i)}) rotate(-45)")
            .text((d, i) => @model.columnNames[i] )

        @addRows()


        if @model.options.tagFile
            @addTags()

        # bootstrap tooltip
        @$("rect.cell").tooltip
            title: ->
                @__data__.condition.split("_").join(" ") + "<br>" + d3.round(@__data__.value,2)  # TODO: refactor this using gsub()
            placement: "top"

        @$("rect.tag").tooltip
            title: ->
                @__data__
            placement: "top"

    calculateRightMargin: ->
        maxrowNameLength = d3.max(@model.rowNames.map (x)-> x.length)
        maxrowNameLength*18 # px per letter

    addRows: ->
        that = @
        getRow = (row) ->
            cell = d3.select(@).selectAll(".cell")
                .data(row)
              .enter().append("rect")
                .attr("class", "cell")
                .attr("x", (d,i) => that.x(i))
                .attr("width", that.x.rangeBand())
                .attr("height", that.x.rangeBand())
                .text((d) -> d)
                .style("fill", (d) => that.heatmapColor(d.value))

        # Add rows
        rows = @heatmap.selectAll(".row")
            .data(@model.longitudinalData)
          .enter().append("g")
            .attr("class", "row")
            .attr("row-id", (d,i)=> @model.rowIds[i])
            .attr("cluster", (d,i) => @model.clusters[i])
            .attr("transform", (d, i)  => "translate(0,#{@y(i)})")
            .each(getRow)

        # Add row names
        unless @model.options.hideRowNames
            rows.append("text")
                .attr("x", @width + @calculateRightMargin())
                .attr("y", @x.rangeBand() / 2)
                .attr("dy", ".32em")
                .attr("text-anchor", "end") # right aligned
                .text((d, i) => @model.rowNames[i])

    addTags: ->
        tags = ""
        $.ajax
          url: @model.options.tagFile,
          context: document.body,
          async: false, # don't know how to do this asynchronously
          success: (data)->
            tags = window.parseTags(data)

        tagNames = window.getTagNames(tags)
        maxTagNameLength = d3.max(tagNames.map (x)-> x.length)*12 # px per letter
        tagSize = @cellSize/2
        tagMargin = 12
        heatmapWidth = d3.select("#heatmap").node().offsetWidth

        tagScale = d3.scale.ordinal()
            .domain(d3.range(tagNames.length))
            .rangeBands([0, (tagNames.length-1)*(tagSize+tagMargin)]);

        @heatmap.selectAll(".row").selectAll(".tag")
            .data((d,i) => tags[@model.rowNames[i]]) # we do this to avoid using the current data
          .enter().append("rect")
            .attr("class", "tag")
            .attr("x", heatmapWidth) # use heatmap width to know where to place the first column of tags
            .attr("y", @x.rangeBand() / 4)
            .attr("transform", (d, i)=> "translate(" + tagScale(tagNames.indexOf(d))+",0)")
            .attr("width", @x.rangeBand()/2)
            .attr("height", @x.rangeBand()/2)
            .attr("row-id", (d)-> d)
            .text((d)-> d )
            .style("fill", (d,i)-> window.tagColor(d))
            .style("stroke", "none")

        # add tag names
        @heatmap.selectAll(".tag_name")
            .data(tagNames)
          .enter().append("text")
            .attr("class","tag_name")
            .attr("dx", heatmapWidth + 10) # so the text is aligned with the square
            .attr("dy",0)
            .attr("transform", (d, i)-> "translate(" + tagScale(tagNames.indexOf(d))+",0) rotate(-45 #{heatmapWidth} 0)")
            .attr("text-anchor", "start")
            .attr("name",(d)-> d)
            .text((d)-> d)
            .attr("fill","black")


        # update heatmap width
        d3.select("#heatmap").attr("width", parseInt(d3.select("#heatmap").attr("width")) + tagNames.length*25 + 100)



    changeCurrentRowId: (e)->
        e.stopPropagation()
        @model.set currentRowId: if e.type=="mouseover" then d3.select(e.target.parentNode).attr("row-id") else null

    changeClickedRowId: (e)->
        e.stopPropagation()
        @model.set clickedRowId: d3.select(e.target.parentNode).attr("row-id")

    changeCurrentTag: (e)->
        e.stopPropagation()

        # silent change of cluster
        @model.attributes['currentCluster'] = null
        d3.selectAll(".clusters span").classed("current",0)

        d3.selectAll(".tag_name").classed("current",0)
        currentTag = d3.select(e.target)
        if currentTag && @model.get("currentTag") == currentTag.attr("name")
            @model.set currentTag: null
        else
            d3.selectAll(".tag_name[row-id=#{currentTag.text()}]").classed("current",1)
            @model.set currentTag: currentTag.text()

    showCurrentRow: ->
        d3.selectAll(".row").filter(":not(.clicked)").classed("current",0)

        currentRowIdId = @model.get "currentRowIdId"
        if currentRowIdId?
            currentRowId = @heatmap.select("[row-id=#{currentRowIdId}]")
            currentRowId.classed("current",1)

    showClickedRow: ->
        clickedRowId = @model.get "clickedRowId"
        if clickedRowId?
            clickedRow = @heatmap.select("[row-id=#{clickedRowId}]")

            # clickedRow.style("visibility","visible") # I'd like to be able to show a row when clicked on PCP from a non-current cluster, but it doesn't work yet

            # update position of PCP
            d3.select("#pcp").style("top", Math.max(150,clickedRow.filter(".row").node().offsetParent.scrollTop)+50)

            @removeClickedRow()
            clickedRow.classed("current clicked",1)

    removeClickedRow: ->
        d3.selectAll(".row").classed("current clicked",0)

    showCurrentCluster: ->
        currentCluster = @model.get("currentCluster")

        $(".row").hide()

        if currentCluster
            rowsToUpdate = @heatmap.selectAll(".row[cluster='#{currentCluster}']")
        else
            rowsToUpdate = @heatmap.selectAll(".row")

        $(rowsToUpdate[0]).show()

        rowsToUpdate
            .attr("transform", (d, i) => "translate(0,#{@y(i)})") # so they are all contiguous

    showCurrentTag: ->
        currentTag = @model.get("currentTag")

        $(".row").hide()

        # learn how to do data.filter properly, so you can change color of .tag_column

        if currentTag
            rowsToUpdate = d3.selectAll($(".tag[row-id='#{currentTag}']").parent())
        else
            rowsToUpdate = @heatmap.selectAll(".row")

        $(rowsToUpdate[0]).show()

        rowsToUpdate
            .attr("transform", (d, i) => "translate(0,#{@y(i)})") # so they are all contiguous




