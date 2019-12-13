############
### copy ###
############

module.exports = (gulp, gulpPlugins, config, utils)->
  # copyHtml
  gulp.task 'copyHtml', ->
    return gulp.src utils.createSrcArr 'html'
    .pipe gulpPlugins.changed config.publishDir
    .pipe gulpPlugins.plumber errorHandler: utils.errorHandler 'copyHtml'
    .pipe gulp.dest config.publishDir
    .pipe gulpPlugins.debug title: gulpPlugins.util.colors.cyan('[copyHtml]:')


  # copyCss
  gulp.task 'copyCss', ->
    stream = gulp.src utils.createSrcArr 'css'
    .pipe gulpPlugins.changed config.publishDir
    .pipe gulpPlugins.plumber errorHandler: utils.errorHandler 'copyCss'

    if config.sourcemap
      stream = stream
      .pipe gulpPlugins.sourcemaps.init()
      stream = utils.postCSS stream
      .pipe gulpPlugins.sourcemaps.write '.'
    else
      stream = utils.postCSS stream

    return stream
    .pipe gulp.dest config.publishDir
    .pipe gulpPlugins.debug title: gulpPlugins.util.colors.cyan('[copyCss]:')


  # copyJs
  gulp.task 'copyJs', ->
    stream = gulp.src utils.createSrcArr 'js'
    .pipe gulpPlugins.changed config.publishDir
    .pipe gulpPlugins.plumber errorHandler: utils.errorHandler 'copyJs'

    if config.minify.js and config.env isnt 'develop'
      if config.sourcemap
        stream = stream
        .pipe gulpPlugins.sourcemaps.init()
        .pipe gulpPlugins.uglify { output: { comments: 'some' } }
        .pipe gulpPlugins.sourcemaps.write '.'
      else
        stream = stream.pipe gulpPlugins.uglify { output: { comments: 'some' } }

    return stream
    .pipe gulp.dest config.publishDir
    .pipe gulpPlugins.debug title: gulpPlugins.util.colors.cyan('[copyJs]:')


  # copyJson
  gulp.task 'copyJson', gulp.series('jsonlint', ->
    return gulp.src utils.createSrcArr 'json'
    .pipe gulpPlugins.changed config.publishDir
    .pipe gulpPlugins.plumber errorHandler: utils.errorHandler 'copyJson'
    .pipe gulp.dest config.publishDir
    .pipe gulpPlugins.debug title: gulpPlugins.util.colors.cyan('[copyJson]:')
  )


  # copyImg
  gulp.task 'copyImg', ->
    return gulp.src utils.createSrcArr 'img'
    .pipe gulpPlugins.changed config.publishDir
    .pipe gulpPlugins.plumber errorHandler: utils.errorHandler 'copyImg'
    .pipe gulp.dest config.publishDir
    .pipe gulpPlugins.debug title: gulpPlugins.util.colors.cyan('[copyImg]:')


  # copyOthers
  gulp.task 'copyOthers', ->
    return gulp.src utils.createSrcArr 'others'
    .pipe gulpPlugins.changed config.publishDir
    .pipe gulpPlugins.plumber errorHandler: utils.errorHandler 'copyOthers'
    .pipe gulp.dest config.publishDir
    .pipe gulpPlugins.debug title: gulpPlugins.util.colors.cyan('[copyOthers]:')
