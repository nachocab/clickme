window.clusterColor = d3.scale.category10()
window.tagColor = d3.scale.category20()
window.no_tag = "-"

window.parseTags = (content)->
        tag_lines = d3.csv.parseRows(content)

        tags = {}
        tag_lines.map (tag_line)->
            values = tag_line.slice(1)
            tags[tag_line[0]] = if values.indexOf(window.no_tag) == -1 then values else []
        tags

window.getFrequencies = (array)->
    frequencies = {};
    _.chain(array).groupBy((p)-> p).each((e, i)-> frequencies[i] = _.size(e))
    frequencies

window.getTagNames = (tags)->
    tagValues = _.chain(tags).values().flatten()
    tagFrequencies = window.getFrequencies(tagValues.value())
    tagValues.unique().sortBy((x)-> tagFrequencies[x]).value().reverse()

window.replace = (array, replaceItem, replaceWith) ->
    for item in array
        if item == replaceItem then replaceWith else item

window.isNumber = (n) ->
    !isNaN(parseFloat(n)) and isFinite(n)

window.getUrlVars = ->
    vars = {}
    window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/g, (m, key, value) ->
        vars[key] = value
    )
    vars

window.resetOnClick = (model)->
    d3.select("body").on("click", ()->
        model.set({ clickedRowId: null })
        model.set({ currentTag: null })
        d3.selectAll(".tag_name").classed("current", 0)
        model.set({ currentCluster: null })
        d3.selectAll(".clusters span").classed("current", 0)
    )

window.joinSentence = (arr)->
    arr2 = arr.slice(0) # otherwise pop modifies arr
    last = arr2.pop()
    if arr2.length > 0
        sentence = arr2.join(", ")
        sentence + " and " + last
    else
        last