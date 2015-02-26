// Generated by CoffeeScript 1.8.0
(function() {
  define(["paper"], function(paper) {
    var Color, Group, Path;
    Color = paper.Color, Group = paper.Group, Path = paper.Path;
    return (function() {
      function _Class(canvas) {
        paper.setup(canvas);
        this.project = paper.project;
        this.view = this.project.view;
        this.tools = {
          pen: {
            blendMode: "source-over"
          },
          eraser: {
            blendMode: "destination-out"
          }
        };
        this.tool = "pen";
        this.color = new Color;
        this.size = 5;
        this.paths = {};
        this.group = new Group;
        this.closed = false;
      }

      _Class.prototype.setTool = function(tool) {
        if (tool in this.tools) {
          this.tool = tool;
        }
        return this;
      };

      _Class.prototype.setColor = function(color) {
        this.color = color;
        return this;
      };

      _Class.prototype.setSize = function(size) {
        this.size = size;
        return this;
      };

      _Class.prototype.begin = function(id) {
        this.project.activate();
        if (!this.group.visible) {
          this.group.removeChildren();
          this.group.setVisible(true);
        }
        this.paths[id] = new Path({
          strokeColor: this.color,
          strokeWidth: this.size,
          blendMode: this.tools[this.tool].blendMode
        });
        this.group.addChild(this.paths[id]);
        return this;
      };

      _Class.prototype.add = function(point, id) {
        if (this.paths[id] != null) {
          this.paths[id].add(point);
          this.view.draw();
        }
        return this;
      };

      _Class.prototype.end = function(id) {
        if (this.paths[id] != null) {
          this.paths[id].simplify(10);
          delete this.paths[id];
        }
        this.view.draw();
        return this;
      };

      _Class.prototype.hide = function() {
        this.end();
        this.group.setVisible(false);
        this.view.draw();
        return this;
      };

      _Class.prototype.show = function() {
        this.group.setVisible(true);
        this.view.draw();
        return this;
      };

      return _Class;

    })();
  });

}).call(this);

//# sourceMappingURL=Path.js.map
