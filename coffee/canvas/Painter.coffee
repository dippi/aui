define ["./Image", "./Path", "./Zoom"], (Image, Path, Zoom) ->

  # General proxy handler for canvases.
  class
    # Setups the specific handlers given
    # the ID or the HTML element of each canvas.
    #
    # @param image [String, DOMCanvas] The canvas to use for images
    # @param path [String, DOMCanvas] The canvas to use for paths
    constructor: (image, path) ->
      @image = new Image image
      @path = new Path path
      @zoomer = new Zoom [@image.view, @path.view]

    # Shows the given image.
    #
    # @param image [String] The url of the img
    # @param width [Number] The original width of img
    # @param height [Number] The original height of img
    showImage: (image, width, height) ->
      @image.show image, [width, height]
      @zoomer.setBounds [0, 0, width, height]
      @

    # Hides the image
    hideImage: ->
      @image.hide()
      @

    # Sets the tools properties
    #
    # @param tool [String] ("pen"|"eraser") The tool type
    # @param color [String] The color of the tool
    # @param size [Number] The size of the tool
    setTool: ({tool, color, size}) ->
      @path.setTool tool
      @path.setColor color
      @path.setSize size
      @

    # Set the current path position
    #
    # @param point [Object] The position point
    # @option point x [Number] The x coordinate
    # @option point y [Number] The y coordinate
    # @param id [Number] The index of the path
    setPoint: (point, id = 0) ->
      @path.add point, id
      @

    # Hides the draw from the canvas.
    hidePath: ->
      @path.hide()
      @

    # Shows the draw on the canvas.
    showPath: ->
      @path.show()
      @

    # Begin a new path
    #
    # @param id [Number] The index of the path
    beginPath: (id = 0) ->
      @path.begin(id)
      @

    # Ends and simplify the path
    #
    # @param id [Number] The index of the path
    endPath: (id = 0) ->
      @path.end(id)
      @

    # Resize the canvases
    #
    # @param width [Number] The new width
    # @param height [Number] The new height
    resize: (width, height) ->
      size = [ width, height ]
      @image.view.setViewSize size
      @path.view.setViewSize size
      @

    # Fits the image to the view
    fit: ->
      @zoomer.fit()
      @

    # Sets the zoom of the canvases with respect to the given scale center
    #
    # @param zoom [Number] The zoom value
    # @param center [Object] The scale center
    # @option center x [Number] The x coordinate
    # @option center y [Number] The y coordinate
    zoom: (zoom, center) ->
      @zoomer.zoom(zoom, center)
      @

    # Change the zoom of a given scale factor, with respect to the scale center
    #
    # @param scale [Number] The scale factor
    # @param center [paper.Point] The scale center
    scale: (scale, center) ->
      @zoomer.scale(scale, center)
      @

    # Scrolls the view of the canvases of a given vector
    #
    # @param vector [Object] The translation vector
    # @option vector x [Number] The x coordinate
    # @option vector y [Number] The y coordinate
    scroll: (vector) ->
      @zoomer.scroll(vector)
      @

    # Calculates the absolute position respect to the drawings coordinates
    # of a given point on the surface of the canvas
    #
    # @param point [Object] The point to transform
    # @option point x [Number] The x coordinate
    # @option point y [Number] The y coordinate
    #
    # @return [Object] The transformed point
    # @option x [Number] The x coordinate
    # @option y [Number] The y coordinate
    absolutePoint: (point) ->
      @zoomer.absolutePoint(point)
