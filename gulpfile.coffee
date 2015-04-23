gulp = require 'gulp'
{PluginError} = require 'gulp-util'
yaml = require 'gulp-yaml'
plumber = require 'gulp-plumber'
{merge} = require 'lodash'
webpack = require 'webpack'
{join} = require 'path'

gulp.task 'default', [
  'webpack'
  'manifest'
  'watch'
]
gulp.task 'build', [
  'webpack-prod'
  'manifest'
  'deploy'
]

do ->
  config =
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

  callback = (err, stats) ->
    throw new PluginError 'webpack', err if err?
    console.log stats.toString
      colors: true
      chunkModules: false

  gulp.task 'webpack', ->
    webpack config, callback
    return

  gulp.task 'webpack-prod', ->
    c = merge config,
      watch: false
      # will be breaks code
      # plugins: [
      #   new webpack.optimize.UglifyJsPlugin
      #     compress:
      #       drop_console: true
      # ]
    webpack c, callback
    return

gulp.task 'manifest', ->
  gulp
    .src ['src/manifest.yml']
    .pipe plumber()
    .pipe yaml()
    .pipe gulp.dest 'dist'

gulp.task 'deploy', ->

gulp.task 'watch', ->
  gulp
    .watch [
      'src/manifest.yml'
    ], [
      'manifest'
    ]
