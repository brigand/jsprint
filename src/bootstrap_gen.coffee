bootstrapLink = "//netdna.bootstrapcdn.com/bootstrap/3.0.0-rc1/css/bootstrap.min.css"

addClass = (element, newClass) ->
  current = element.className.split(" ")
  current.push newClass
  element.className = current.join ' '

constructors =
  Number: Number
  String: String
  Object: JSON.parse
  Array: JSON.parse

bootstrap =
  row:  ->
    element = document.createElement "div"
    element.className = "row"
    element
  list: (array=[], onchange) ->
    ul = document.createElement 'ul'
    ul.className = 'list-group'
    inputs = []
    handleChange = ->
      # We need to cast these into their original types

      data = for inp in inputs
        con = constructors[inp.type.name] or inp.type
        con inp.el.value
      onchange(data)

    for item in array
      li = document.createElement 'li'
      li.className = 'list-group-item'
      if typeof onchange is "function"
        input = bootstrap.input()
        input.value =
          switch typeof item
            when "string" then item
            when "number" then item.toString()
            else JSON.stringify(item)

        input.addEventListener 'keyup', handleChange
        inputs.push {el: input, type: item.constructor}
        li.appendChild input
      else
        li.textContent = item.toString()

      ul.appendChild(li)
    ul

  input: ->
    input = document.createElement 'input'
    input.className = "form-control"
    input.type = "text"
    input

  h: (level, text) ->
    header = document.createElement 'h' + level.toString()
    header.textContent = text
    header

  pre: (text) ->
    pre = document.createElement 'pre'
    pre.textContent = text
    pre

  panel: (kind="info") ->
    panel = document.createElement 'div'
    panel.className = 'panel panel-' + kind
    panel

  panelHead: (text) ->
    head = document.createElement 'div'
    head.className = 'panel-heading'
    head.textContent = text
    head

  getBootstrap: ->
    unless bootstrap.weHaveBootstrap()
      link = document.createElement 'link'
      link.href = bootstrapLink
      link.type = "text/css"
      link.rel = "stylesheet"
      document.head.appendChild link
  weHaveBootstrap: ->
    for ss in document.styleSheets
      fileName = ss.href?.split("/").slice(-1)?[0] or ""
      if fileName.indexOf("bootstrap") isnt -1
        return true
    false

@bootstrap = bootstrap