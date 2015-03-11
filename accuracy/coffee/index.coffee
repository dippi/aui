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

initialize = ($, Painter, host, shadow, config) ->

  painter = new Painter $("#image", shadow)[0], $("#reference", shadow)[0], $("#draw", shadow)[0]

  i = Math.floor(Math.random() * config.images.length)
  url = config.images[i].image
  refUrl = config.images[i].reference
  width = config.images[i].width
  height = config.images[i].height
  
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

require [ "jquery", "../accuracy/js/canvas/Painter", "../accuracy/js/config"], ($, Painter, config) ->
  $ ->
    proto = Object.create HTMLElement.prototype
    tmpl = $ "template", thatDocument

    proto.attributeChangedCallback = -> $(window).trigger "resize"

    proto.attachedCallback = ->
      clone = document.importNode tmpl[0].content, true
      shadow = @createShadowRoot()

      shadow.appendChild clone

      initialize $, Painter, @, shadow, config

    document.registerElement 'accuracy-game', prototype: proto
