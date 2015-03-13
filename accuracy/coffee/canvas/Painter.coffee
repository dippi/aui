define ["./Image", "./Path", "./Zoom"], (Image, Path, Zoom) ->

  # General proxy handler for canvases.
  class
    # Setups the specific handlers given
    # the ID or the HTML element of each canvas.
    #
    # @param image [String, HTMLCanvasElement] The canvas to use for images
    # @param reference [String, HTMLCanvasElement] The canvas to use for references paths
    # @param path [String, HTMLCanvasElement] The canvas to use for paths
    constructor: (image, reference, path) ->
      @image = new Image image
      @reference = new Image reference
      @path = new Path path
      @zoomer = new Zoom [@image.view, @reference.view, @path.view]

      @pathCanv = path
      @refCanv = reference

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

    # Show the path to replace
    #
    # @param image [String] The url of the img
    # @param width [Number] The original width of img
    # @param height [Number] The original height of img
    showReference: (image, width, height) ->
      @reference.show image, [width, height]
      @

    # Hides the reference path
    hideReference: ->
      @reference.hide()
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
      @reference.view.setViewSize size
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

    # Compute the accuracy of the draw w.r.t. the refernce path
    #
    # @return [Number] The accuracy score
    getAccuracy: ->
      { width, height } = @pathCanv
      pathData = @pathCanv.getContext '2d'
        .getImageData 0, 0, width, height
        .data
      refData = @refCanv.getContext '2d'
        .getImageData 0, 0, width, height
        .data

      correct = drawn = 0

      for i in [0...height]
        for j in [0...width]
          k = (i * width + j) * 4 + 3
          if pathData[k] isnt 0
            ++drawn
            ++correct if refData[k] isnt 0

      Math.round((correct / drawn) * 100) or 0