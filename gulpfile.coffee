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

gulp.task 'test', ->

gulp.task 'manifest', ->
  gulp
    .src ['src/manifest.yml']
    .pipe plumber()
    .pipe yaml()
    .pipe gulp.dest 'dist'

###
curl \
-H "Authorization: Bearer ya29.XwFAO-SHiUwaDFxiiPqK-gsrgOGq7-jUzmxtgsXGC0YRjW4I2hzEumGMcASvzfMl_utk29NTYeH4Xw"  \
-H "x-goog-api-version: 2" \
-X POST \
-T dist.zip \
-v \
https://www.googleapis.com/upload/chromewebstore/v1.1/items

curl \
-H "Authorization: Bearer ya29.XwFAO-SHiUwaDFxiiPqK-gsrgOGq7-jUzmxtgsXGC0YRjW4I2hzEumGMcASvzfMl_utk29NTYeH4Xw"  \
-H "x-goog-api-version: 2" \
-X PUT \
-T dist.zip \
-v \
https://www.googleapis.com/upload/chromewebstore/v1.1/items/ipaedoakpcpcapkijmoamckhcdjcclbh
###

gulp.task 'watch', ->
  gulp
    .watch [
      'src/manifest.yml'
    ], [
      'manifest'
    ]
