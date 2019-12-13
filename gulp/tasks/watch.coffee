#############
### watch ###
#############

connectSSI = require 'connect-ssi'
module.exports = (gulp, gulpPlugins, config, utils)->
  gulp.task 'watch', ->
    gulpPlugins.watch utils.createSrcArr('html'),   gulp.series('copyHtml')
    gulpPlugins.watch utils.createSrcArr('css'),    gulp.series('copyCss')
    gulpPlugins.watch utils.createSrcArr('js'),     gulp.series('copyJs')
    gulpPlugins.watch utils.createSrcArr('json'),   gulp.series('copyJson')
    gulpPlugins.watch utils.createSrcArr('img'),    gulp.series('copyImg')
    gulpPlugins.watch utils.createSrcArr('others'), gulp.series('copyOthers')
    gulpPlugins.watch utils.createSrcArr('pug'),    gulp.series('pug')
    gulpPlugins.watch utils.createSrcArr('sass'),   gulp.series('sass')

    # インクルードファイル(アンスコから始まるファイル)更新時はすべてをコンパイル
    gulpPlugins.watch config.filePath.pugInclude,  gulp.series('pugAll')
    gulpPlugins.watch config.filePath.sassInclude, gulp.series('sassAll')

    for task in config.optionsWatchTasks then task()

    return gulp.src config.publishDir
    .pipe gulpPlugins.webserver
      livereload:
        enable: true
        filter: (fileName)-> return !fileName.match(/.map$/)
      port: 50000
      open: 'http://127.0.0.1:50000' + config.serverDefaultPath
      directoryListing: false
      host: '0.0.0.0'
      https: config.https
      middleware:
        connectSSI
          baseDir: config.publishDir
          ext: '.html'
    .pipe gulpPlugins.notify "[watch]: start local server. http://127.0.0.1:50000#{config.serverDefaultPath}"
