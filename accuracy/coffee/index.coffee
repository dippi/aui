thatDocument = document.currentScript.ownerDocument

debounce = (func, wait, immediate) ->
  timeout = context = args = callNow = null

  later = ->
    timeout = null
    if not callNow then func.apply context, args

  ->
    context = @
    args = arguments
    callNow = immediate and not timeout?
    clearTimeout timeout
    timeout = setTimeout later, wait
    if callNow then func.apply context, args

initialize = ($, Painter, host, shadow, paper) ->

  painter = new Painter $("#image", shadow)[0], $("#reference", shadow)[0], $("#draw", shadow)[0]

  # url = "https://upload.wikimedia.org/wikipedia/commons/9/99/Leonardo_Sala_delle_Asse_detail.jpg"
  # width = 804
  # height = 1031
  url = "accuracy/img/image.jpg"
  refUrl = "accuracy/img/path.png"
  width = 1920
  height = 1280
  painter.showImage url, width, height
  painter.showReference refUrl, width, height

  painter.setTool
    tool: "pen"
    color: "red"
    size: 10

  viewport = $ '#viewport', shadow

  resize = ->
    painter.resize viewport.width(), viewport.height()
    painter.fit()

  resize()

  $ window
    .on "resize", debounce resize, 200, true

  $host = $ host

  transformToElement = ({x, y}) ->
    offset = $host.offset()
    x -= offset.left
    y -= offset.top

    if $host.css("transform") isnt "none"
      x = $host.width() - x
      y = $host.height() - y

    {x, y}

  viewport.on "touchstart", ({originalEvent: e}) ->
    for touch in e.changedTouches
      painter.beginPath touch.identifier
      painter.setPoint(
        painter.absolutePoint transformToElement
          x: touch.pageX
          y: touch.pageY
        touch.identifier
      )
    return

  viewport.on "touchmove", ({originalEvent: e}) ->
    offset = $host.offset();
    for touch in e.changedTouches
      painter.setPoint(
        painter.absolutePoint transformToElement
          x: touch.pageX
          y: touch.pageY
        touch.identifier
      )
    return

  viewport.on "touchend touchcancel", ({originalEvent: e}) ->
    offset = $host.offset();
    for touch in e.changedTouches
      painter.setPoint(
        painter.absolutePoint transformToElement
          x: touch.pageX
          y: touch.pageY
        touch.identifier
      )
      painter.endPath touch.identifier
    return

  # TODO: think an alternative for zooming
  # viewport.on "mousewheel", (e) ->
  #   scale = if e.deltaY > 0 then 2 else 1/2
  #   center = painter.absolutePoint
  #     x: e.pageX
  #     y: e.pageY
  #   painter.scale scale, center
  #   painter.setPoint center
  
  $ '#end-game', shadow
    .on "click", ->
      $ '#results', shadow
        .removeClass "hidden"
        .find "#accuracy"
        .text painter.getAccuracy()
  
  $ "#exit", shadow
    .on "click", ->
      $ '#results', shadow
        .addClass "hidden"
      painter.hidePath()
      $host.trigger "quit"

require [ "jquery", "../accuracy/js/canvas/Painter"], ($, Painter) ->
  $ ->
    proto = Object.create HTMLElement.prototype
    tmpl = $ "template", thatDocument

    proto.attributeChangedCallback = -> $(window).trigger "resize"

    proto.attachedCallback = ->
      clone = document.importNode tmpl[0].content, true
      shadow = @createShadowRoot()

      shadow.appendChild clone

      initialize $, Painter, @, shadow

    document.registerElement 'accuracy-game', prototype: proto
