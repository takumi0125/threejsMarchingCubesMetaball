############
### pug ###
############

through2 = require 'through2'

module.exports = (gulp, gulpPlugins, config, utils)->
  pugOptions =
    basedir: config.srcDir
    pretty: true

  if config.minify.html and config.env isnt 'develop'
    pugOptions.pretty = false

  # pug
  gulp.task 'pug', ->
    return gulp.src utils.createSrcArr 'pug'
    .pipe gulpPlugins.changed config.publishDir, { extension: '.html' }
    .pipe gulpPlugins.plumber errorHandler: utils.errorHandler 'pug'
    .pipe gulpPlugins.data ->
      data = require(config.pugData)(config.env)
      data.env = config.env
      return data
    .pipe gulpPlugins.pug(pugOptions)
    .pipe gulp.dest config.publishDir
    .pipe gulpPlugins.debug title: gulpPlugins.util.colors.cyan('[pug]:')

  # pugAll
  gulp.task 'pugAll', ->
    return gulp.src utils.createSrcArr 'pug'
    .pipe gulpPlugins.plumber errorHandler: utils.errorHandler 'pugAll'
    .pipe gulpPlugins.data ->
      data = require(config.pugData)(config.env)
      data.env = config.env
      return data
    .pipe gulpPlugins.pug(pugOptions)

    # update timestamp
    .pipe through2.obj((file, enc, cb)=>
      date = new Date();
      file.stat.atime = date;
      file.stat.mtime = date;
      cb(null, file);
    )

    .pipe gulp.dest config.publishDir
    .pipe gulpPlugins.debug title: gulpPlugins.util.colors.cyan('[pugAll]:')
