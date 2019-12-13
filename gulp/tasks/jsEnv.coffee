##############
### jsEnv ###
##############

module.exports = (gulp, gulpPlugins, config, utils)->
  # coffee
  fs = require('fs')
  gulp.task 'jsEnv', (callback)->
    data = require(config.pugData)(config.env)
    jsEnv =
      projectName: config.projectName
      env: config.env
      siteUrl: data.siteUrl
    code = 'module.exports = ' + JSON.stringify(jsEnv, null, '  ')
    fs.writeFileSync(config.jsEnv, code, 'utf8')
    return callback()
