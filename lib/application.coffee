$ ->

  class window.Entry extends Spine.Model
    @configure 'Entry', 'weight'
    @extend Spine.Model.Local

    @weights: ->
      Entry.all().map (entry)->
        return entry.weight

    @currentWeight: ->
      parseInt(Entry.all()[Entry.all().length-1].weight)

    @targetWeights: ->
      Entry.all().map (entry)->
        return (184 - parseInt(entry.weight))

    @ratings: ->
      Entry.all().map (entry)->
        return entry.rating

  class Entries extends Spine.Controller
    events:
      "click .delete": "delete"

    constructor: ->
      super
      @entry.bind('update', @render)
      @entry.bind("destroy", @release)

    render: =>
      @replace($("#template").tmpl(@entry))
      @

    delete: ->
      @entry.destroy()

  class App extends Spine.Controller
    events:
      'keyup input[name=weight]': 'create'
      'click input[name=weight]': 'initInput'
      'blur input[name=weight]':  'initInput'

    elements:
      ".entries":           "entries"
      "input[name=weight]": "input"
      ".sparklines":        "sparkline"
      ".barchart":          "barchart"
      "#currentWeight":     "currentWeight"
      "#donut":             "donut"

    constructor: ->
      super
      Entry.bind("refresh", @addAll)
      Entry.bind("create",  @addOne)
      Entry.bind("refresh change", @drawSparkLine)
      Entry.bind("refresh change", @updateCurrentWeight)
      Entry.fetch()

    create: (event)->
      event.preventDefault()
      if event.keyCode == 13
        new Entry(weight: @input.val()).save()
        @input.val('')

    initInput: ->
      if @input.val() == "Enter weight:"
        @input.val('')
      else
        @input.val('Enter weight:')

    addAll: =>
      Entry.each(@addOne)

    addOne: (entry)=>
      @entries.prepend(new Entries(entry: entry).render().el)

    drawSparkLine: =>
      @sparkline.sparkline(Entry.weights());

    updateCurrentWeight: =>
      @currentWeight.html(Entry.currentWeight())
      @donut.css({width: Entry.currentWeight() - 50})


  new App(el: $("#app"))