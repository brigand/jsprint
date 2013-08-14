rootElement = document.createElement 'div'
rootElement.className = 'container'
row = null

if document.body?.appendChild
  document.body.appendChild(rootElement)
  bootstrap.getBootstrap()
else
  document.addEventListener "DOMContentLoaded", ->
    document.body.appendChild(rootElement)
    bootstrap.getBootstrap()

class FunctionWatcher
  constructor: (@fun, @args) ->
    @container = bootstrap.row()
    params = bootstrap.list @args, @updateResult.bind(this)
    @resultView = document.createElement 'div'

    @container.appendChild params
    @container.appendChild @resultView

    @updateResult(@args)

  updateResult: (newArgs) ->
    try
      result = @fun newArgs...
    catch error
      errorNode = handleError error, true

    for child in @resultView.children
      @resultView.removeChild child

    if errorNode?
      @resultView.appendChild errorNode
    else
      node = printToNode result, [], true
      @resultView.appendChild node

jsprint = (what, other...) ->
  node = printToNode(what, other)
  if jsprint.condenced
    if row is null or row.children.length is 2
      row = bootstrap.row()
      rootElement.appendChild row
    node.className = 'col-6'
    row.appendChild node
  else
    rootElement.appendChild node
  return

panelTypes =
  "Function": "primary"
  "Arrray": "warning"
  "String": "info"
  Default: "success"


printToNode = (what, other, notitle=false) ->
  panelType = panelTypes[what.constructor.name] or panelTypes.Default
  switch what.constructor.name
    when "Function"
      watcher = new FunctionWatcher(what, other)
      title = (what.name or "anonymousFunction")
      body = watcher.container
    when "Array"
      title = 'Array'
      body = bootstrap.list(what)
    when "String"
      switch other.length
        when 0
          title = "String"
          body = bootstrap.pre what
        else
          title = what
          # Recurse so that we can handle arrays/objects correctly
          body = printToNode other[0], other[1...], true
          if panelTypes[other[0].constructor.name]
            panelType = panelTypes[other[0].constructor.name]
    else
      title = what.constructor.name
      body = bootstrap.pre JSON.stringify(what, null, 4)
  unless notitle
    panel = bootstrap.panel(panelType or panelTypes.Default)
    if jsprint.condenced
      panel.className += " col-6"
    panel.appendChild bootstrap.panelHead(title)
    panel.appendChild body
    panel
  else
    body

handleError = (e, returnNode) ->
  node = printToNode "Your code isnt running", [e]
  node.className += "panel-danger"
  if returnNode is true
    return node
  else
    rootElement.appendChild node
    return false

if typeof window.onerror is "function"
  errorCopy = window.onerror
  window.onerror = ->
    errorCopy.apply window, arguments
    handleError.apply window, arguments
else
  window.onerror = handleError

@jsprint = jsprint
jsprint['condenced'] = false
jsprint['setRootElement'] = (el) -> rootElement = el