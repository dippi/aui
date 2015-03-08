require ["jquery"], ($) ->
  $ ->
    $ window
      .on "contextmenu", (e) -> e.preventDefault()

    jtl = $ ".join.top.left"
    jtr = $ ".join.top.right"
    jbr = $ ".join.bottom.right"
    jbl = $ ".join.bottom.left"

    ftl = $ ".frame.top.left"
    ftr = $ ".frame.top.right"
    fbr = $ ".frame.bottom.right"
    fbl = $ ".frame.bottom.left"

    jbl.on "click", ->
      jbl.addClass "hidden"
      fbl.removeClass "hidden"
        .attr "src", "page.html"
      jtr.removeClass "hidden"

    jtr.on "click", ->
      jtr.addClass "hidden"
      fbl.addClass "half-width"
      fbr.addClass "half-width"
      ftl.addClass "half-width"
      ftr.addClass "half-width"
        .removeClass "hidden"
        .attr "src", "page.html"
      jtl.removeClass "hidden"
      jbr.removeClass "hidden"

    jtl.on "click", ->
      jtl.addClass "hidden"
      fbl.addClass "half-height"
      ftl.addClass "half-height"
        .removeClass "hidden"
        .attr "src", "page.html"

    jbr.on "click", ->
      jbr.addClass "hidden"
      ftr.addClass "half-height"
      fbr.addClass "half-height"
        .removeClass "hidden"
        .attr "src", "page.html"
