{ Rectangle, Matrix, Point } = paper

# Handles the zoom of all the given overlapped canvases
class window.Zoom
  # Constructor that takes the views to handle
  #
  # @param views [paper.Views] The views to handle
  constructor: (@views) ->
    @image = new Rectangle 0,0,0,0
    @min = 1

  # Sets the bounds of current image to compute limits of zoom
  # and set the zoom to fit the given rectangle
  #
  # @param image [paper.Rectangle] The bounds of the image
  setBounds: (image) ->
    @image = new Rectangle image

    ratio = @views[0].size.divide @image.size
    @min = Math.min 1, ratio.width, ratio.height

    @zoom @min

  # Sets the zoom of the canvases with respect to the given scale center
  #
  # The zoom value should be in the interval [min, max],
  # where min (<= 1) is the value to fit the image in the view
  # and max (= 1) is the value to see the image in its real dimensions
  #
  # @param zoom [Number] The zoom value
  # @param center [paper.Point] The scale center
  zoom: (zoom, center) ->
    zoom = Math.max Math.min(1, zoom), @min

    matrix = @fixMatrix new Matrix().scale(zoom / @views[0].zoom, center)

    for i, view of @views
      view._transform matrix
      view._zoom = zoom

  # Change the zoom of a given scale factor, with respect to the scale center
  #
  # @see this.zoom
  #
  # @param scale [Number] The scale factor
  # @param center [paper.Point] The scale center
  scale: (scale, center) ->
    @zoom @views[0].zoom * scale, center

  # Scrolls the view of the canvases of a given vector
  #
  # @param vector [paper.Point] The translation vector
  scroll: (vector) ->
    vector = new Point(vector).divide(@views[0].zoom).negate()

    matrix = @fixMatrix new Matrix().translate(vector)

    for i, view of @views
      view._transform matrix

  # Checks and fixes the issue of having the image out of the view bounds
  #
  # @param matrix [paper.Matrix] The transformation matrix to fix
  #
  # @return [paper.Matrix] A fixed new matrix
  fixMatrix: (matrix) ->
    matrix = new Matrix matrix

    box = @views[0].bounds
    image = @image
    vector = new Point 0, 0

    box = new Rectangle(
      matrix.inverseTransform box.topLeft
      matrix.inverseTransform box.bottomRight
    )

    if image.width < box.width
      vector.x = box.center.x - image.center.x
    else if image.left > box.left
      vector.x = box.left - image.left
    else if image.right < box.right
      vector.x = box.right - image.right

    if image.height < box.height
      vector.y = box.center.y - image.center.y
    else if image.top > box.top
      vector.y = box.top - image.top
    else if image.bottom < box.bottom
      vector.y = box.bottom - image.bottom

    matrix.translate vector

  # Calculates the absolute position respect to the drawings coordinates
  # of a given point on the surface of the canvas
  #
  # @param point [paper.Point] The point to transform
  #
  # @return [paper.Point] The transformed point
  absolutePoint: (point) ->
    @views[0].viewToProject point
