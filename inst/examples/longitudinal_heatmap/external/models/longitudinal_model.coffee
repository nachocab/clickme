 class window.LongitudinalModel extends Backbone.Model
    defaults =
        currentRowId: null
        clickedRowId: null
        currentCluster: null
        currentTag: null

    initialize: (parsedData, userOptions = {})->
        @options =
            rowNameColumn: userOptions.rowNameColumn || "id"
            yAxisName: userOptions.yAxisName || "log-ratio"
            specialColumnNames: userOptions.specialColumnNames || ["cluster"]
            rowType: userOptions.rowType
            tagFile: userOptions.urlVars["tags"]
            showGroups: userOptions.urlVars["groups"]
            hideHeatmap: userOptions.urlVars["no_heatmap"]
            hidePCP: userOptions.urlVars["no_pcp"]
            hideRowNames: userOptions.urlVars["no_row_names"]

        @options.specialColumnNames = _.union(@options.specialColumnNames, @options.rowNameColumn)

        @parsedData = parsedData # array of objects with column names as properties
        @rowNames = _.pluck(@parsedData, @options.rowNameColumn)
        @rowIds = ("_row_#{id}" for id in [1..(@parsedData.length)])
        @columnNames = @getColumnNames()
        @columnGroups = @getColumnGroups()

        @longitudinalData = @getLongitudinalData()
        @groupedLongitudinalData = @getGroupedLongitudinalData()

        @clusters = _.pluck(@parsedData, "cluster")
        @options.showClusters = (_.uniq(@clusters).length > 1)
        @clusterNames = @getClusterNames()

    getRowName: (rowName)->
        @rowNames[@rowIds.indexOf(rowName)]

    getColumnGroups: ->
        _.chain(@columnNames).map((columnName)-> columnName.split("_")[0]).uniq().value()

    getLongitudinalValueExtent: ->
        longitudinalValues = _.flatten(@longitudinalData.map (longitudinalDataRow)->
            longitudinalDataRow.map (item)->
                item.value
        )
        d3.extent(longitudinalValues)

    getColumnNames: ->
        # we look at the first object and assume every other object will have the same column names
        _.keys(@parsedData[0]).filter (columnName) =>
            !_.include(@options.specialColumnNames, columnName)

    # Returns an object for each row, with two properties: condition and value
    getLongitudinalData: ->
        @parsedData.map (row) =>
            @columnNames.map (columnName) ->
                condition: columnName
                value: +row[columnName] # make numeric

    # TODO refactor
    getGroupedLongitudinalData: ->
        @parsedData.map (row) =>
            columnGroups = @columnGroups.slice(0); # to avoid @columnGroups.shift!()
            currentGroup = columnGroups.shift()

            longitudinalValues = []
            @columnNames.map (columnName) =>
                # add a null datapoint when changing column groups
                unless columnName.match ///^#{currentGroup}_///
                    longitudinalValues.push {condition: "", value: null}
                    currentGroup = columnGroups.shift()
                longitudinalValues.push {condition: columnName, value: +row[columnName]}

            longitudinalValues

    # cluster names sorted by descending frequency of parsedData
    getClusterNames: ->
        clusterFrequencies = window.getFrequencies(@clusters)
        _.chain(clusterFrequencies).keys().sortBy((x)-> clusterFrequencies[x]).value().reverse()
