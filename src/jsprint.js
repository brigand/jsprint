// Generated by CoffeeScript 1.6.3
(function() {
  var FunctionWatcher, errorCopy, handleError, jsprint, panelTypes, printToNode, rootElement, row,
    __slice = [].slice;

  rootElement = document.createElement('div');

  rootElement.className = 'container';

  row = null;

  document.addEventListener("DOMContentLoaded", function() {
    document.body.appendChild(rootElement);
    return bootstrap.getBootstrap();
  });

  FunctionWatcher = (function() {
    function FunctionWatcher(fun, args) {
      var params;
      this.fun = fun;
      this.args = args;
      this.container = bootstrap.row();
      params = bootstrap.list(this.args, this.updateResult.bind(this));
      this.resultView = document.createElement('div');
      this.container.appendChild(params);
      this.container.appendChild(this.resultView);
      this.updateResult(this.args);
    }

    FunctionWatcher.prototype.updateResult = function(newArgs) {
      var child, error, errorNode, node, result, _i, _len, _ref;
      try {
        result = this.fun.apply(this, newArgs);
      } catch (_error) {
        error = _error;
        errorNode = handleError(error, true);
      }
      _ref = this.resultView.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        this.resultView.removeChild(child);
      }
      if (errorNode != null) {
        return this.resultView.appendChild(errorNode);
      } else {
        node = printToNode(result, [], true);
        return this.resultView.appendChild(node);
      }
    };

    return FunctionWatcher;

  })();

  jsprint = function() {
    var node, other, what;
    what = arguments[0], other = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    node = printToNode(what, other);
    if (jsprint.condenced) {
      if (row === null || row.children.length === 2) {
        row = bootstrap.row();
        rootElement.appendChild(row);
      }
      node.className = 'col-6';
      row.appendChild(node);
    } else {
      rootElement.appendChild(node);
    }
  };

  panelTypes = {
    "Function": "primary",
    "Arrray": "warning",
    "String": "info",
    Default: "success"
  };

  printToNode = function(what, other, notitle) {
    var body, panel, panelType, title, watcher;
    if (notitle == null) {
      notitle = false;
    }
    panelType = panelTypes[what.constructor.name] || panelTypes.Default;
    switch (what.constructor.name) {
      case "Function":
        watcher = new FunctionWatcher(what, other);
        title = what.name || "anonymousFunction";
        body = watcher.container;
        break;
      case "Array":
        title = 'Array';
        body = bootstrap.list(what);
        break;
      case "String":
        switch (other.length) {
          case 0:
            title = "String";
            body = bootstrap.pre(what);
            break;
          default:
            title = what;
            body = printToNode(other[0], other.slice(1), true);
            if (panelTypes[other[0].constructor.name]) {
              panelType = panelTypes[other[0].constructor.name];
            }
        }
        break;
      default:
        title = what.constructor.name;
        body = bootstrap.pre(JSON.stringify(what, null, 4));
    }
    if (!notitle) {
      panel = bootstrap.panel(panelType || panelTypes.Default);
      if (jsprint.condenced) {
        panel.className += " col-6";
      }
      panel.appendChild(bootstrap.panelHead(title));
      panel.appendChild(body);
      return panel;
    } else {
      return body;
    }
  };

  handleError = function(e, returnNode) {
    var node;
    node = printToNode("Your code isnt running", [e]);
    node.className += "panel-danger";
    if (returnNode === true) {
      return node;
    } else {
      rootElement.appendChild(node);
      return false;
    }
  };

  if (typeof window.onerror === "function") {
    errorCopy = window.onerror;
    window.onerror = function() {
      errorCopy.apply(window, arguments);
      return handleError.apply(window, arguments);
    };
  } else {
    window.onerror = handleError;
  }

  this.jsprint = jsprint;

  jsprint['condenced'] = false;

  jsprint['setRootElement'] = function(el) {
    return rootElement = el;
  };

}).call(this);

/*
//@ sourceMappingURL=jsprint.map
*/
