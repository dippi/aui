// Generated by CoffeeScript 1.8.0
(function() {
  define(["./Image", "./Path", "./Zoom"], function(Image, Path, Zoom) {
    return (function() {
      function _Class(image, reference, path) {
        this.image = new Image(image);
        this.reference = new Image(reference);
        this.path = new Path(path);
        this.zoomer = new Zoom([this.image.view, this.reference.view, this.path.view]);
        this.pathCanv = path;
        this.refCanv = reference;
      }

      _Class.prototype.showImage = function(image, width, height) {
        this.image.show(image, [width, height]);
        this.zoomer.setBounds([0, 0, width, height]);
        return this;
      };

      _Class.prototype.hideImage = function() {
        this.image.hide();
        return this;
      };

      _Class.prototype.showReference = function(image, width, height) {
        this.reference.show(image, [width, height]);
        return this;
      };

      _Class.prototype.hideReference = function() {
        this.reference.hide();
        return this;
      };

      _Class.prototype.setTool = function(_arg) {
        var color, size, tool;
        tool = _arg.tool, color = _arg.color, size = _arg.size;
        this.path.setTool(tool);
        this.path.setColor(color);
        this.path.setSize(size);
        return this;
      };

      _Class.prototype.setPoint = function(point, id) {
        if (id == null) {
          id = 0;
        }
        this.path.add(point, id);
        return this;
      };

      _Class.prototype.hidePath = function() {
        this.path.hide();
        return this;
      };

      _Class.prototype.showPath = function() {
        this.path.show();
        return this;
      };

      _Class.prototype.beginPath = function(id) {
        if (id == null) {
          id = 0;
        }
        this.path.begin(id);
        return this;
      };

      _Class.prototype.endPath = function(id) {
        if (id == null) {
          id = 0;
        }
        this.path.end(id);
        return this;
      };

      _Class.prototype.resize = function(width, height) {
        var size;
        size = [width, height];
        this.image.view.setViewSize(size);
        this.reference.view.setViewSize(size);
        this.path.view.setViewSize(size);
        return this;
      };

      _Class.prototype.fit = function() {
        this.zoomer.fit();
        return this;
      };

      _Class.prototype.zoom = function(zoom, center) {
        this.zoomer.zoom(zoom, center);
        return this;
      };

      _Class.prototype.scale = function(scale, center) {
        this.zoomer.scale(scale, center);
        return this;
      };

      _Class.prototype.scroll = function(vector) {
        this.zoomer.scroll(vector);
        return this;
      };

      _Class.prototype.absolutePoint = function(point) {
        return this.zoomer.absolutePoint(point);
      };

      _Class.prototype.getAccuracy = function() {
        var correct, drawn, height, i, j, k, pathData, refData, width, _i, _j, _ref;
        _ref = this.pathCanv, width = _ref.width, height = _ref.height;
        pathData = this.pathCanv.getContext('2d').getImageData(0, 0, width, height).data;
        refData = this.refCanv.getContext('2d').getImageData(0, 0, width, height).data;
        correct = drawn = 0;
        for (i = _i = 0; 0 <= height ? _i < height : _i > height; i = 0 <= height ? ++_i : --_i) {
          for (j = _j = 0; 0 <= width ? _j < width : _j > width; j = 0 <= width ? ++_j : --_j) {
            k = (i * width + j) * 4 + 3;
            if (pathData[k] !== 0) {
              ++drawn;
              if (refData[k] !== 0) {
                ++correct;
              }
            }
          }
        }
        return Math.round((correct / drawn) * 100) || 0;
      };

      return _Class;

    })();
  });

}).call(this);

//# sourceMappingURL=Painter.js.map