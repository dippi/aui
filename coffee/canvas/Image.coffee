define ["paper"], (paper) ->

  { Raster, Size } = paper

  window.painter ?= {}

  # Shows an image in the relative canvas
  class
    # Given the ID or the HTML element of the canvas,
    # setups paper project, raster and cut mask.
    #
    # @param canvas [String, DOMCanvas] The canvas to use
    constructor: (canvas) ->
      paper.setup canvas
      @project = paper.project
      @view = @project.view

      @raster = new Raster
        visible: false

      @raster.on "load", =>
        @raster.setVisible true

    # Draws on the canvas an image rescaled
    # to fit the view size.
    #
    # @param image [String] The url of the img
    # @param size [paper.Size] The original size of img
    show: (image, size) ->
      @raster.setSource image
      @raster.setPosition new Size(size).divide(2)
      @

    # Hides the image from the canvas.
    hide: ->
      @raster.setVisible false
      @view.draw()
      @
