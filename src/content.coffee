{createClass, createElement: $, render} = require 'react'
md2react = require 'imports?React=react!md2react'
require 'style!css!../node_modules/github-markdown-css/github-markdown.css'

Markdown = createClass
  render: ->
    $ 'div', {className: 'markdown-body'}, [@state.content]
  getInitialState: -> content: ''
  componentDidMount: ->
    md = document.body.textContent
    console.log 'componentDidMount', md
    @update md
  update: (md) ->
    console.log 'update:', md
    content = md2react md,
      gfm:true
      breaks: true
      tables: true
    @setState {content}

el = $ Markdown, {}
app = render el, document.body

do ->
  xmlhttp = new XMLHttpRequest
  url = location.href
  isLocalFile = /^file:\/\//i.test(url)
  return unless isLocalFile

  fetch = ->
    console.log 'fetch --------------'
    xmlhttp.abort()
    xmlhttp.open "GET", url + '?rnd=' + new Date().getTime(), true
    xmlhttp.send()

  onFetched = (text) ->
    console.log 'onFetched:', text
    app.update text

  [idFetch] = []
  xmlhttp.onreadystatechange = ->
    console.log 'onreadystatechange'
    clearTimeout idFetch
    console.log xmlhttp.readyState, xmlhttp.status
    if xmlhttp.readyState is 4 and xmlhttp.status isnt 404
      onFetched xmlhttp.responseText
      idFetch = setTimeout fetch, 1000
      return
  fetch()
