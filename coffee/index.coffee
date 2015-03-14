require ["jquery"], ($) ->
  $ ->
    $ window
      .on "contextmenu", (e) -> e.preventDefault()

    class Corner
      constructor: (@button, @frame, @list, @row, @col) ->
        @visible = false

        @button.on "click", =>
          @activate true

          @halfHeight @list[(@row + 1) % 2][@col].visible
          @halfWidth @list[(@row + 1) % 2][@col].visible or
            @list[0][(@col + 1) % 2].visible or
            @list[1][(@col + 1) % 2].visible

          @list[(@row + 1) % 2][@col]
            .halfHeight true
            .halfWidth true
          @list[0][(@col + 1) % 2]
            .halfWidth true
          @list[1][(@col + 1) % 2]
            .halfWidth true

        @frame.on "quit", =>
          @activate false
          @list[(@row + 1) % 2][@col]
            .halfHeight false
            .halfWidth @list[0][(@col + 1) % 2].visible or
              @list[1][(@col + 1) % 2].visible
          @list[0][(@col + 1) % 2]
            .halfWidth @list[(@row + 1) % 2][@col].visible or
              @list[1][(@col + 1) % 2].visible
          @list[1][(@col + 1) % 2]
            .halfWidth @list[0][(@col + 1) % 2].visible or
              @list[(@row + 1) % 2][@col].visible

      activate: (flag) ->
        @visible = flag
        @button.toggleClass "hidden", flag
        @frame.toggleClass "hidden", not flag
        @

      halfWidth: (flag) ->
        @frame.toggleClass "half-width", flag
        @

      halfHeight: (flag) ->
        @frame.toggleClass "half-height", flag
        @


    state = [[],[]];

    state[0][0] = new Corner(
      $ ".join.top.left"
      $ ".frame.top.left"
      state
      0
      0
    )

    state[0][1] = new Corner(
      $ ".join.top.right"
      $ ".frame.top.right"
      state
      0
      1
    )

    state[1][0] = new Corner(
      $ ".join.bottom.left"
      $ ".frame.bottom.left"
      state
      1
      0
    )

    state[1][1] = new Corner(
      $ ".join.bottom.right"
      $ ".frame.bottom.right"
      state
      1
      1
    )
