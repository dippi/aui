require [ "underscore", "jquery", "canvas/Painter", "mousewheel" ], (_, $, Painter) ->
  $ ->
    { debounce } = _

    painter = new Painter "image", "draw", "position"

    url = "http://upload.wikimedia.org/wikipedia/commons/9/99/Leonardo_Sala_delle_Asse_detail.jpg"
    painter.showImage url, 804, 1031

    painter.setName "PlayerOne"
    painter.setTool
      tool: "pen"
      color: "red"
      size: 3

    viewport = $ '#viewport'
    $window = $ window

    started = false

    resize = ->
      painter.resize viewport.width(), viewport.height()
      painter.fit()

    resize()

    $window.on "resize", debounce resize, 200

    viewport.on "mousedown", (e) ->
      if not started
        started = true
        painter.beginPath()
        painter.setPoint painter.absolutePoint
          x: e.pageX
          y: e.pageY

    viewport.on "mousemove", (e) ->
      painter.setPoint painter.absolutePoint
        x: e.pageX
        y: e.pageY

    $window.on "mouseup", (e) ->
      if started
        started = false
        painter.setPoint painter.absolutePoint
          x: e.pageX
          y: e.pageY
        painter.endPath()

    viewport.on "mousewheel", (e) ->
      scale = if e.deltaY > 0 then 2 else 1/2
      center = painter.absolutePoint
        x: e.pageX
        y: e.pageY
      painter.scale scale, center
      painter.setPoint center
