# General proxy handler for canvases.
class window.Painter
  # Setups the specific handlers given
  # the ID or the HTML element of each canvas.
  #
  # @param image [String, DOMCanvas] The canvas to use for images
  # @param path [String, DOMCanvas] The canvas to use for paths
  # @param position [String, DOMCanvas] The canvas to use for positions
  constructor: (image, path, position) ->
    @image = new Image image
    @path = new Path path
    @position = new Position position
    @zoom = new Zoom [image.view, path.view, position.view]

  # Shows the given image.
  #
  # @param image [String] The url of the img
  # @param width [Number] The original width of img
  # @param height [Number] The original height of img
  showImage: (image, width, height) ->
    @image.show image, [width, height]
    @zoom.setBounds [0, 0, width, height]

  # Hides the image
  hideImage: ->
    @image.hide()

  # Sets the tools properties
  #
  # @param tool [String] ("pen"|"eraser") The tool type
  # @param color [String] The color of the tool
  # @param size [Number] The size of the tool
  setTool: ({tool, color, size}) ->
    @path.setTool tool

    @position.setColor color
    @path.setColor color

    @position.setSize size
    @path.setSize size

  # Set the name label for the cursor
  #
  # @param name [String] The name of the sketcher
  setName: (name) ->
    @position.setText name

  # Set the current position point
  # for position and path
  #
  # @param point [Object] The position point
  # @option point x [Number] The x coordinate
  # @option point y [Number] The y coordinate
  setPoint: (point) ->
    @position.draw point
    @path.add point

  # Hides the position from the canvas.
  hidePosition: ->
    @position.hide()

  # Shows the position on the canvas.
  showPosition: ->
    @position.show()

  # Hides the draw from the canvas.
  hidePath: ->
    @path.hide()

  # Shows the draw on the canvas.
  showPath: ->
    @path.show()

  # Begin a new path
  beginPath: ->
    @path.begin()

  # Ends and simplify the path
  endPath: ->
    @path.end()

  # Sets the zoom of the canvases with respect to the given scale center
  #
  # @param zoom [Number] The zoom value
  # @param center [Object] The scale center
  # @option center x [Number] The x coordinate
  # @option center y [Number] The y coordinate
  zoom: (zoom, center) ->
    @zoom.zoom(zoom, center)

  # Scrolls the view of the canvases of a given vector
  #
  # @param vector [Object] The translation vector
  # @option vector x [Number] The x coordinate
  # @option vector y [Number] The y coordinate
  scroll: (vector) ->
    @zoom.scroll(vector)

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
    res = @zoom.absolutePoint(point)
    { x: res.x, y: res.y }
