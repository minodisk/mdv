gulp = require 'gulp'
webpack = require 'webpack'
{join} = require 'path'

gulp.task 'default', [
  'build'
  'watch'
]

gulp.task 'build', ->
  webpack
    watch: true
    colors: true
    entry:
      content: './src/content'
    output:
      path: join __dirname, 'dist'
      filename: 'mdv-[name].js'
    resolve:
      extensions: ['', '.js', '.coffee']
    module:
      loaders: [
        test: /\.coffee$/
        loader: 'coffee-loader'
      ]
  , (err, stats) ->
    throw new PluginError 'webpack', err if err?
    console.log stats.toString
      colors: true
      chunkModules: false
  return

gulp.task 'watch', ->
