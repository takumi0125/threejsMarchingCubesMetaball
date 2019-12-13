###############
### default ###
###############

notifier = require 'node-notifier'

module.exports = (gulp, gulpPlugins, config, utils)->
  gulp.task('default', gulp.series(
    'clean'
    gulp.parallel('json', 'sprites', 'jsEnv')
    gulp.parallel('html', 'css', 'js', 'copyImg', 'copyOthers')
    (callback)->
      callback()
      utils.msg gulpPlugins.util.colors.yellow '\n====================\n build complete !!\n===================='
      notifier.notify title: 'gulp', message: 'build complete!!'
      return
    )
  )
