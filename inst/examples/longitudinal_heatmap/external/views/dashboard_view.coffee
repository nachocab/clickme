class window.DashboardView extends Backbone.View
    initialize: ->
        @render()

        # model changes that update the view
        @model.on "change:currentCluster", => @showTitle()
        @model.on "change:currentTag", => @showTitle()

    events: ->
        # mouse events that change the model
        "click #dashboard .clusters span": "changeCurrentCluster"

    changeCurrentCluster : (e)->
        e.stopPropagation()

        # silent change of tag
        @model.attributes['currentTag'] = null
        d3.selectAll(".tag_name").classed("current",0)

        currentCluster = d3.select(e.target)
        d3.selectAll(".clusters span").classed("current",0)

        if currentCluster && @model.get("currentCluster") == currentCluster.attr("name")
            @model.set currentCluster: null
        else
            currentCluster.classed("current",1)
            @model.set currentCluster: currentCluster.attr("name")

    showTitle: ->
        title = "#{@getCurrentRows().length} #{@model.options.rowType}"

        if @model.options.showGroups
             title += " from #{joinSentence(@model.columnGroups)}"

        if @model.options.showClusters && (currentCluster = @model.get("currentCluster"))
            title += " (Cluster #{currentCluster})"

        if @model.options.showTags && (currentTag = @model.get("currentTag"))
            title += " (Tagged #{currentTag})"

        d3.select("title").text(title)
        d3.select("#dashboard h1").text(title)

    # determine which rows must be shown in heatmap/pcp
    getCurrentRows: ()->
        if @model.options.showClusters && (currentCluster = @model.get("currentCluster"))
            d3.selectAll(".row[cluster='#{currentCluster}']")[0]
        else if @model.options.showTags && (currentTag = @model.get("currentTag"))
            d3.selectAll(".tag[name='#{currentTag}']")[0]
        else
            @model.parsedData

    render: ->
        @showTitle()

        # add cluster buttons
        if @model.options.showClusters
            d3.select("#dashboard .clusters").selectAll("span")
                .data(@model.clusterNames)
              .enter().append("span")
                .attr("name", (d) -> d)
                .text((d)-> "Cluster #{d}")
                .style("background", (d)=> window.clusterColor(d))


