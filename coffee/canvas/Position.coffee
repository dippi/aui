define ["paper"], (paper) ->

  { Rectangle, Color, Path: { Circle }, PointText, Group, Size } = paper

  window.painter ?= {}

  # Show the sketcher cursor current position.
  class
    # Given the ID or the HTML element of the canvas,
    # setups paper project, tool circle and name flag.
    #
    # @param canvas [String, DOMCanvas] The canvas to use
    constructor: (canvas) ->
      paper.setup canvas
      @project = paper.project
      @view = @project.view

      @bounds = new Rectangle
      @color = new Color
      @text = ""

      @circle = new Circle
        radius: 5

      @pointText = new PointText
        font: "monospace"

      @group = new Group
        children: [@circle, @pointText]
        visible: false

      @changed = false

    # Sets the size of the tool.
    #
    # @param size [Number] The tool size
    setSize: (size) ->
      @bounds.setSize new Size size, size
      @changed = true
      @

    # Sets the color of the tool.
    #
    # @param color [paper.Color] The tool color
    setColor: (@color) ->
      @changed = true
      @

    # Sets the text label with the current sketcher name.
    #
    # @param text [String] The name of the sketcher
    setText: (@text) ->
      @changed = true
      @

    # Draws the cursor position on the canvas.
    #
    # @param position [paper.Point] The current position
    draw: (position) ->
      if @changed
        @circle.setStrokeColor @color
        @pointText.setFillColor @color

        @bounds.setCenter position

        @circle.fitBounds @bounds

        @pointText.setContent @text
        @pointText.setPosition @bounds.topCenter.subtract [0, @pointText.bounds.height]

        @changed = false
      else
        delta = @bounds.center.subtract(position).negate()
        @group.translate delta
        @bounds.setCenter position

      @group.setVisible true
      @view.draw()
      @

    # Hides the position from the canvas.
    hide: ->
      @group.setVisible false
      @view.draw()
      @

    # Shows the position if hidden
    show: ->
      @group.setVisible true
      @view.draw()
      @
