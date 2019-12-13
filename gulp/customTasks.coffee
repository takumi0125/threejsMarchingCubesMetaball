####################
### custom tasks ###
####################

module.exports = (gulp, gulpPlugins, config, utils)->
  # lib.js
  utils.createJsConcatTask(
    'concatLibJs'
    [
      "#{config.srcDir}/#{config.assetsDir}/js/_lib/TweenMax.min.js"
      "#{config.srcDir}/#{config.assetsDir}/js/_lib/threejs/three.min.js"
      "#{config.srcDir}/#{config.assetsDir}/js/_lib/threejs/WebGL.js"
      "#{config.srcDir}/#{config.assetsDir}/js/_lib/threejs/TrackballControls.js"
    ]
    "#{config.publishDir}/#{config.assetsDir}/js"
    'lib'
  )


  # head js
  utils.createWebpackJsTask(
    "headJs"
    [ "#{config.srcDir}/#{config.assetsDir}/js/_head/init.js" ]
    [
      "#{config.srcDir}/#{config.assetsDir}/js/_modules/**/*"
      "#{config.srcDir}/#{config.assetsDir}/js/_head/**/*"
    ]
    "#{config.publishDir}/#{config.assetsDir}/js"
    'head'
  )

  # sync contents js
  for name in ['index']
    utils.createWebpackJsTask(
      "#{name}Js"
      [ "#{config.srcDir}/#{config.assetsDir}/js/_#{name}/init.js" ]
      [
        "#{config.srcDir}/#{config.assetsDir}/js/_modules/**/*"
        "#{config.srcDir}/#{config.assetsDir}/js/_#{name}/**/*"
      ]
      "#{config.publishDir}/#{config.assetsDir}/js"
      name
    )