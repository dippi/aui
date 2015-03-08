define ["paper"], (paper) ->

  { Color, Group, Path } = paper

  # Draw the path of the sketcher
  class
    # Given the ID or the HTML element of the canvas,
    # setups paper project.
    #
    # @param canvas [String, DOMCanvas] The canvas to use
    constructor: (canvas) ->
      paper.setup canvas
      @project = paper.project
      @view = @project.view

      @tools =
        pen:
          blendMode: "source-over"
        eraser:
          blendMode: "destination-out"

      @tool = "pen"
      @color = new Color
      @size = 5

      @paths = {}
      @group = new Group

      @closed = false

    # Switch the mode between pen and eraser
    #
    # @param tool [String] ("pen"|"eraser") The tool type
    setTool: (tool) ->
      if tool of @tools
        @tool = tool
      @

    # Sets the color of the path
    #
    # @param color [paper.Color] The color of the path
    setColor: (@color) -> @

    # Sets the size of the path
    #
    # @param size [Number] The size of the path
    setSize: (@size) -> @

    # Begins a path with the given properties
    # (If the paths were hidden before, deletes
    # them cleaning the canvas)
    #
    # @param id [Number] The index of the path
    begin: (id) ->
      @project.activate()

      if not @group.visible
        @group.removeChildren()
        @group.setVisible true

      @paths[id] = new Path
        strokeColor: @color
        strokeWidth: @size
        blendMode: @tools[@tool].blendMode

      @group.addChild @paths[id]
      @

    # Adds a point at the end of current path
    #
    # @param point [paper.Point] The point to add
    # @param id [Number] The index of the path
    add: (point, id) ->
      if @paths[id]?
        @paths[id].add point
        @view.draw()
      @

    # Ends a path and apply the simplification on it
    #
    # @param id [Number] The index of the path
    end: (id) ->
      if @paths[id]?
        @paths[id].simplify 10
        delete @paths[id]

      @view.draw()
      @

    # Hides the draws
    hide: ->
      @end()
      @group.setVisible false

      @view.draw()
      @

    # Shows the paths if hidden
    show: ->
      @group.setVisible true
      @view.draw()
      @
