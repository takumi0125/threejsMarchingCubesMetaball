#
# フロントエンド開発用 汎用gulpテンプレート
#

# modules
gulp        = require 'gulp'
gulpPlugins = require('gulp-load-plugins')()

# config
config = require './gulp/config'
config.env = gulpPlugins.util.env.env || 'develop'

# --env=staging or --env=productionオプションが指定されている場合はsourcemapは作らない
config.sourcemap = config.env is 'develop'

# utils
utils = require('./gulp/utils')(gulp, gulpPlugins, config)

utils.msg gulpPlugins.util.colors.yellow "\n----------------------\n env: #{config.env}\n----------------------"


# --------------------------
#  各種内部変数 (configに追加)
# --------------------------

# sprites生成のタスク名を格納する配列
config.spritesTaskNames = []

# JS連結のタスク名を格納する配列
config.jsConcatTaskNames = []

# オプションのウォッチタスクを格納する配列
config.optionsWatchTasks = []



# --------------------------
#  タスク定義
# --------------------------

### 基本タスク ###

# jsEnv
require('./gulp/tasks/jsEnv')(gulp, gulpPlugins, config, utils)

# clean
require('./gulp/tasks/clean')(gulp, gulpPlugins, config, utils)

# json
require('./gulp/tasks/json')(gulp, gulpPlugins, config, utils)

# copy
require('./gulp/tasks/copy')(gulp, gulpPlugins, config, utils)

# pug (jade)
require('./gulp/tasks/pug')(gulp, gulpPlugins, config, utils)

# sass
require('./gulp/tasks/sass')(gulp, gulpPlugins, config, utils)


###
カスタムタスク
JSの結合, Browserify, Webpack, spritesmithのタスク定義
基本的にはプロジェクトごとにこのファイルとconfigを編集することになる
###

require('./gulp/customTasks')(gulp, gulpPlugins, config, utils)


### 複合タスク ###

# html
gulp.task 'html', gulp.parallel('copyHtml', 'pug')

# css
gulp.task 'css', gulp.parallel('copyCss', 'sass')

# json
gulp.task 'json', gulp.series('copyJson')

# js
gulp.task 'js', gulp.parallel.apply({}, config.jsConcatTaskNames.concat([ 'copyJs' ]))

# sprites
if config.spritesTaskNames.length is 0 then config.spritesTaskNames[0] = (callback)-> return callback()
gulp.task 'sprites', gulp.parallel.apply({}, config.spritesTaskNames)


### watchタスク (watch & ローカルサーバを起動) ###

require('./gulp/tasks/watch')(gulp, gulpPlugins, config, utils)


### defaultタスク ###

require('./gulp/tasks/default')(gulp, gulpPlugins, config, utils)
