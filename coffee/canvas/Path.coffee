{ Color, Group, Path } = paper

# Draw the path of the sketcher
class window.Path
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

    @path = null
    @group = new Group

    @closed = false

  # Switch the mode between pen and eraser
  #
  # @param tool [String] ("pen"|"eraser") The tool type
  setTool: (tool) ->
    if tool of @tools
      @tool = tool

  # Sets the color of the path
  #
  # @param color [paper.Color] The color of the path
  setColor: (@color) ->

  # Sets the size of the path
  #
  # @param size [Number] The size of the path
  setSize: (@size) ->

  # Begins a path with the given properties
  # (If the paths were hidden before, deletes
  # them cleaning the canvas)
  begin: ->
    @project.activate()

    if not @group.visible
      @group.removeChildren()
      @group.setVisible true

    @path = new Path
      strokeColor: @color
      strokeWidth: @size
      blendMode: @tools[@tool].blendMode

    @group.addChild @path

  # Adds a point at the end of current path
  #
  # @param point [paper.Point] The point to add
  add: (point) ->
    if @path isnt null
      @path.add point
      @view.draw()

  # Ends a path and apply the simplification on it
  end: ->
    if @path isnt null
      @path.simplify 10
      @path = null

    @view.draw()

  # Hides the draws
  hide: ->
    @end()
    @group.setVisible false

    @view.draw()

  # Shows the paths if hidden
  show: ->
    @group.setVisible true
    @view.draw()
