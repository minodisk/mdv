{createClass, createElement: $, render} = require 'react'
md2react = require 'imports?React=react!md2react'
require 'style!css!../node_modules/github-markdown-css/github-markdown.css'

createMdElement = (md) ->
  md2react md,
    gfm:true
    breaks: true
    tables: true

Markdown = createClass
  render: ->
    $ 'div', {className: 'markdown-body'}, [@state.content]
  getInitialState: ->
    console.log 'getInitialState:', document.body.textContent
    md = document.body.textContent
    content: createMdElement md
  componentDidMount: ->
    md = document.body.textContent
    console.log 'componentDidMount:', md
  update: (md) ->
    console.log 'update:', md
    @setState content: createMdElement md

app = render $(Markdown, {}), document.body

do ->
  url = location.href
  isLocalFile = /^file:\/\//i.test(url)
  return unless isLocalFile

  [idFetch, cache] = []

  onReadyStateChange = ->
    clearTimeout idFetch
    if xhr.readyState is 4 and xhr.status isnt 404
      onFetched xhr.responseText
      idFetch = setTimeout fetch, 1000

  fetch = ->
    xhr.abort()
    xhr.open "GET", url + '?' + new Date().getTime(), true
    xhr.send()

  onFetched = (text) ->
    return if text is cache
    app.update text
    cache = text

  xhr = new XMLHttpRequest
  xhr.onreadystatechange = onReadyStateChange
  fetch()
