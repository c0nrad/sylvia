
$(document).ready ->

  PRIMARY_COLOR = "#90CA77"
  SECONDARY_COLOR = "#ff9999"
  THIRD_COLOR = "#C55186"

  COLOR_MAP = 
    "preposistion": "#FF0000"
    "adverb": "#FF7F00"
    "adjective": "#FFFF00"
    "conjunction": "#00FF00"
    "pronoun": "#0000FF"
    "word": "#4B0082"

  app = window || {}

  app.NodeModel = Backbone.Model.extend
    urlRoot: "/api/node"
    idAttribute: "_id"

    isDrawn: ->
      @get('data') in app.G.nodes()

    graph: (c, force) ->
      c ?= COLOR_MAP[@get('type')]
      if !app.queryModel.get('types')[@get('type')] and !force
        return false

      if (not @isDrawn()) or force
        app.G.add_node @get('data'), {color: c}
        return true
      return true
        
  app.LinkModel = Backbone.Model.extend 
    idAttribute: "_id"
    urlRoot: "/api/link"

    defualts: ->
      node1: 1
      node2: 2

    otherNode: (word) ->
      w1 = app.nodes.get @get('node1')
      w2 = app.nodes.get @get('node2')
      if w2.get('data') == word 
        return w1 
      if w1.get('data') == word 
        return w2 
      console.log "SHOULD NOT BE HERE"
      return w1

    graph: () ->
      w1 = app.nodes.get @get('node1')
      w2 = app.nodes.get @get('node2')
      w1.graph()
      w2.graph()
      if w1.isDrawn() and w2.isDrawn()
        app.G.add_edge w1.get('data'), w2.get('data')

  app.QueryModel = Backbone.Model.extend  
    defaults: ->
      words: []
      limit: 10
      types: 
        "preposistion": true
        "adverb": true
        "adjective": true
        "conjunction": true
        "pronoun": true
        "word": true


  app.Nodes = Backbone.Collection.extend
    model: app.NodeModel 
    url: "/api/nodes"

    getModel: (word) ->
      @findWhere {data: word}

    getRelatedModels: (word1, word2) ->
      word1Related = app.links.getRelated word1 
      word2Related = app.links.getRelated word2 
      return _.intersection word1Related, word2Related

  app.Links = Backbone.Collection.extend 
    model: app.LinkModel
    url: "/api/links"

    getRelatedLinks: (word) ->
      m = app.nodes.getModel word
      @filter (l) ->
        l.get('node1') == m.get('_id') or l.get('node2') == m.get('_id')

    getRelated: (word) ->
      m = app.nodes.getModel word
      links = @getRelatedLinks word
      @chain()
      .map (l) ->
        if l.get('node1') == m.get('_id')
          return app.nodes.get l.get('node2')
        else if l.get('node2') == m.get('_id')
          return app.nodes.get l.get('node1')
        else 
          return null
      .compact()
      .value()

    getTopLinks: (word) ->
      m = app.nodes.getModel word
      links = @getRelatedLinks word
      links = _.sortBy links, (l) ->
        -l.get('count')
      if isNaN(app.queryModel.get('limit'))
        return links
      else
        return links[0..app.queryModel.get('limit')]

  app.GraphView = Backbone.View.extend 

    initalize: ->
      #@model.on 'change', @render, @

    render: ->
      app.G = jsnx.Graph()
      @renderQuery()
      @drawGraph()

    drawGraph: ->
      jsnx.draw app.G,
        element: '#canvas' 
        with_labels: true
        weighted: true
        node_attr: 
          r: (d) ->
            return 50;
        node_style: 
          fill: (d) ->
            return d.data.color
      , true
      @updateNodes()


    updateNodes: () ->
      for node in $(".node")
        node.ondblclick = ->
          data = $(@).find('text').text()
          words = app.queryModel.get('words')
          words.push data
          app.queryModel.set 'words', words
          app.graphView.renderQuery()

        node.onclick = ->
          console.log "SINGLECLICK"        

    resetQuery: () ->
      @render()

    addSecondaryNodes: (word) ->
      links = app.links.getTopLinks word
      for link in links 
        link.graph()

    renderQuery: () ->
      for word in app.queryModel.get('words')
        primaryNode = app.nodes.getModel word
        if !primaryNode?
          primaryNode = app.nodes.add {data: word}
        primaryNode.graph(PRIMARY_COLOR, true)
        app.G.node.get(word).color = PRIMARY_COLOR

      for word in app.queryModel.get('words')
        @addSecondaryNodes word


      @updateNodes()

  app.AppView = Backbone.View.extend 
    el: 'body'

    events: 
      'click button[name=query]': 'query'
      'click button[name=clearQuery]': "clearQuery"
      'input input[name=limit]': 'changeLimit'
      'click input[type=checkbox]': 'legendFix'


    legendFix: (e) ->
      checkbox = $(e.currentTarget)
      isOn = checkbox.is(':checked')
      type = checkbox.attr('name')
      types = app.queryModel.get 'types'
      types[type] = isOn
      app.queryModel.set 'types', types
      app.graphView.render()

    clearQuery: ->
      app.queryModel = new app.QueryModel
      app.graphView.render()

    query: ->
      queryString = $('input[name=query]').val()
      app.queryModel.set 'words', queryString.split(' ')
      app.graphView.render()

    changeLimit: ->
      app.queryModel.set 'limit', Number($('input[name=limit').val())
      app.graphView.render()

    drawLegend: ->
      console.log "HAI"
      legendDiv = $('#legend')
      for k in _.keys(COLOR_MAP)
        v = COLOR_MAP[k]
        line = "<p style='background: #{v}'> <input type='checkbox' name='#{k}' checked> #{k} </p>"
        console.log line
        legendDiv.append line

    initialize: ->
      app.nodes = new app.Nodes 
      app.nodes.fetch {async: false}

      app.links = new app.Links 
      app.links.fetch {async: false}

      app.queryModel = new app.QueryModel {words: ["sylvia"]}
      app.graphView = new app.GraphView {model: app.queryModel}
      app.graphView.nodes = app.nodes 
      app.graphView.links = app.links
      app.graphView.render()

      @drawLegend()

  app.appView = new app.AppView

  console.log "OKAU"