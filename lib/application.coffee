$ ->
  # Spine Model
  #
  # Models wrap data
  #
  # Define attributes
  # Define methods
  #
  # Example
  #
  # entry = new Entry
  # entry.weight = 123
  # entry.save
  class Entry extends Spine.Model
    # Define model attributes here
    @configure 'Entry', 'weight'

    # Set persistence driver
    # 
    # E.g LocalStorage, AJAX... etc
    @extend Spine.Model.Local

    # Class methods
    #
    # Entry.weights()
    # Entry.currentWeight()
    @weights: ->
      Entry.all().map (entry)->
        return entry.weight

    @currentWeight: ->
      parseInt(Entry.all()[Entry.all().length-1].weight)

  # Spine Controller
  #
  # Map DOM elements and events to methods
  # Translates model data into visual representation (I.e, HTML Template)
  class Entries extends Spine.Controller
    events:
      "click .delete": "delete"

    # Constructor method
    # 
    # new Entries(entry: entry).render().el
    constructor: ->
      super
      @entry.bind('update', @render)
      @entry.bind("destroy", @release)

    # Render a template for model passed into the constructor as @entry
    render: =>
      @replace($("#template").tmpl(@entry))
      @

    delete: ->
      @entry.destroy()

  # Spine Controller
  #
  # The "main" part of the application
  #
  # Maps events and elements to methods
  class App extends Spine.Controller
    # Call methods (on the right) when HTML/Event (on the left) are triggered
    events:
      'keyup input[name=weight]': 'create'
      'click input[name=weight]': 'initInput'
      'blur input[name=weight]':  'initInput'
    
    # Elements hash creates accessors for HTML DOM Elements mapped to a friendly name
    #
    # elements:
    #   ".entries": "my_name_for_entries_element"
    #
    # @my_name_for_entries == $(".entries")
    #
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


  # Boot it up...
  new App(el: $("#app"))