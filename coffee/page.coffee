require [ "underscore", "jquery", "canvas/Painter", "mousewheel" ], (_, $, Painter) ->
  $ ->
    { debounce } = _

    painter = new Painter "image", "draw"

    url = "http://upload.wikimedia.org/wikipedia/commons/9/99/Leonardo_Sala_delle_Asse_detail.jpg"
    painter.showImage url, 804, 1031

    painter.setTool
      tool: "pen"
      color: "red"
      size: 3

    viewport = $ '#viewport'

    resize = ->
      painter.resize viewport.width(), viewport.height()
      painter.fit()

    resize()

    $ window
      .on "contextmenu", (e) -> e.preventDefault()
      .on "resize", debounce resize, 200

    viewport.on "touchstart", ({originalEvent: e}) ->
      for touch in e.changedTouches
        painter.beginPath touch.identifier
        painter.setPoint(
          painter.absolutePoint
            x: touch.pageX
            y: touch.pageY
          touch.identifier
        )

    viewport.on "touchmove", ({originalEvent: e}) ->
      for touch in e.changedTouches
        painter.setPoint(
          painter.absolutePoint
            x: touch.pageX
            y: touch.pageY
          touch.identifier
        )

    viewport.on "touchend touchcancel", ({originalEvent: e}) ->
      for touch in e.changedTouches
        painter.setPoint(
          painter.absolutePoint
            x: touch.pageX
            y: touch.pageY
          touch.identifier
        )
        painter.endPath touch.identifier

    # TODO: think an alternative for zooming
    # viewport.on "mousewheel", (e) ->
    #   scale = if e.deltaY > 0 then 2 else 1/2
    #   center = painter.absolutePoint
    #     x: e.pageX
    #     y: e.pageY
    #   painter.scale scale, center
    #   painter.setPoint center
