#############
### utils ###
#############

buffer        = require 'vinyl-buffer'
mergeStream   = require 'merge-stream'
source        = require 'vinyl-source-stream'
webpackStream = require 'webpack-stream'
webpack       = require 'webpack'

UglifyJsPlugin = require 'uglifyjs-webpack-plugin'
VueLoaderPlugin = require 'vue-loader/lib/plugin'

autoprefixer = require 'autoprefixer'

_WEBPACK_EXCLUDES = [/\/node_modules\//, /\/bower_components\//, /\/htdocs\//, /\/gulp\//, /\/\.cache-loader\//,/\\node_modules\\/, /\\bower_components\\/, /\\htdocs\\/, /\\gulp\\/, /\\\.cache-loader\\/]

module.exports = (gulp, gulpPlugins, config)->

  #
  # webpack configs
  #

  minify = config.minify.js and config.env isnt 'develop'

  # webpack loaderSettings
  babelLoaderSettings =
    loader: 'babel-loader'
    options:
      presets: [
        [
          '@babel/preset-env'
          {
            modules: false
            targets:
              browsers: config.targetBrowsers
          }
        ]
        '@babel/preset-react'
      ]
      plugins: [
        [
          '@babel/plugin-transform-runtime'
          { corejs: 2 }
        ]
        'transform-react-pug'
      ]

  postCSSLoaderSettings =
    loader: 'postcss-loader'
    options:
      sourceMap: config.sourcemap
      plugins: [ autoprefixer(config.autoprefixerOpt) ]

  sassLoaderSettings =
    loader: 'sass-loader'
    options:
      sourceMap: config.sourcemap

  createCSSLoaderSettings = (importLoaders = 1, modules = false)->
    loader: 'css-loader'
    options:
      modules: modules
      sourceMap: config.sourcemap
      minimize: config.minify.css and config.env isnt 'develop'
      importLoaders: importLoaders


  # webpack config
  webpackConfigBase =
    mode: if config.env isnt 'develop' then 'production' else 'development'
    devtool: if config.sourcemap then 'source-map' else false
    module:
      rules: [

        # js
        {
          test: /\.(js|jsx)$/
          exclude: _WEBPACK_EXCLUDES
          use: [ 'cache-loader', babelLoaderSettings ]
        }

        # coffee
        {
          test: /\.coffee$/
          exclude: _WEBPACK_EXCLUDES
          use: [
            'cache-loader'
            babelLoaderSettings
            {
              loader: 'coffee-loader'
              options: { presets: [ '@babel/preset-react' ] }
            }
          ]
        }

        # .vue
        {
          test: /\.vue$/,
          exclude: _WEBPACK_EXCLUDES
          use: [ 'cache-loader', 'vue-loader' ]
        }

        # .pug
        {
          test: /\.pug$/,
          exclude: _WEBPACK_EXCLUDES
          oneOf: [
            {
              resourceQuery: /^\?vue/
              use: [ 'pug-plain-loader' ]
            },
            { use: [ 'raw-loader', 'pug-plain-loader' ] }
          ]
        }

        # .css
        {
          test: /\.css$/
          exclude: _WEBPACK_EXCLUDES
          oneOf: [
            {
              resourceQuery: /^\?vue/
              use: [
                'vue-style-loader'
                createCSSLoaderSettings(1)
                postCSSLoaderSettings
              ]
            }
            {
              use: [
                'style-loader'
                createCSSLoaderSettings(1, true)
                postCSSLoaderSettings
              ]
            }
          ]
        }

        # .scss
        {
          test: /\.scss$/
          exclude: _WEBPACK_EXCLUDES
          oneOf: [
            {
              resourceQuery: /^\?vue/
              use: [
                'vue-style-loader'
                createCSSLoaderSettings(2)
                sassLoaderSettings
                postCSSLoaderSettings
              ]
            }
            {
              use: [
                'style-loader'
                createCSSLoaderSettings(2, true)
                sassLoaderSettings
                postCSSLoaderSettings
              ]
            }
          ]
        }

        # raw
        {
          test: /\.(html|json|glsl|vert|frag)$/
          exclude: _WEBPACK_EXCLUDES
          use: [ 'raw-loader']
        }

        # glsl
        {
          test: /\.(glsl|vert|frag)$/
          exclude: _WEBPACK_EXCLUDES
          use: [ 'glslify-loader' ]
        }
      ]
    externals:
      "react": 'React'
      "react-dom": 'ReactDOM'
      "vue": 'Vue'

    plugins: [ new VueLoaderPlugin() ]

    resolve:
      extensions: [ '.js', '.glsl', '.vert', '.frag', '.vue', '.jsx', '.scss', '.sass', '.css' ]

  # uglifyJsPlugin
  if config.minify.js and config.env isnt 'develop'
    webpackConfigBase.plugins.push new UglifyJsPlugin({
      parallel: true
      sourceMap: config.sourcemap
      extractComments: true
    })

  utils =
    #
    # spritesmith のタスクを生成
    #
    # @param {String}  taskName      タスクを識別するための名前 すべてのタスク名と異なるものにする
    # @param {String}  imgDir        ソース画像ディレクトリへのパス (ドキュメントルートからの相対パス)
    # @param {String}  cssDir        ソースCSSディレクトリへのパス (ドキュメントルートからの相対パス)
    # @param {String}  outputImgName 指定しなければ#{taskName}.pngになる
    # @param {String}  outputImgPath CSSに記述される画像パス (相対パスの際に指定する)
    #
    # #{config.srcDir}#{imgDir}/_#{taskName}/
    # 以下にソース画像を格納しておくと
    # #{config.srcDir}#{cssDir}/_#{taskName}.scss と
    # #{config.srcDir}#{imgDir}/#{taskName}.png が生成される
    # かつ watch タスクの監視も追加
    #
    createSpritesTask: (taskName, imgDir, cssDir, outputImgName = '', outputImgPath = '') ->
      config.spritesTaskNames.push taskName

      srcImgFiles = "#{config.srcDir}/#{imgDir}/#{config.excrusionPrefix}#{taskName}/*"
      config.filePath.img.push "!#{srcImgFiles}"

      gulp.task taskName, ->

        spriteObj =
          imgName: "#{outputImgName or taskName}.png"
          cssName: "#{config.excrusionPrefix}#{taskName}.scss"
          algorithm: 'binary-tree'
          padding: 2
          # cssOpts:
          #   variableNameTransforms: ['camelize']

        if outputImgPath then spriteObj.imgPath = outputImgPath

        spriteData = gulp.src srcImgFiles
        .pipe gulpPlugins.plumber errorHandler: utils.errorHandler taskName
        .pipe gulpPlugins.spritesmith spriteObj

        imgStream = spriteData.img

        imgStream
        .pipe gulp.dest "#{config.srcDir}/#{imgDir}"
        .pipe gulp.dest "#{config.publishDir}/#{imgDir}"

        cssStream = spriteData.css.pipe gulp.dest "#{config.srcDir}/#{cssDir}"

        return mergeStream imgStream, cssStream

      config.optionsWatchTasks.unshift -> gulpPlugins.watch srcImgFiles, gulp.series(taskName)


    #
    # webpackのタスクを生成 (coffeescript, babel[es2015], glsl使用)
    #
    # @param {String}       taskName        タスクを識別するための名前 すべてのタスク名と異なるものにする
    # @param {Array|String} entries         browserifyのentriesオプションに渡す node-globのシンタックスで指定
    # @param {Array|String} src             entriesを除いた全ソースファイル (watchタスクで監視するため) node-globのシンタックスで指定
    # @param {String}       outputDir       最終的に出力されるjsが格納されるディレクトリ
    # @param {String}       outputFileName  最終的に出力されるjsファイル名(拡張子なし)
    #
    # entries以外のソースファイルを指定する理由は、watchの監視の対象にするためです。
    # 複数の entry ファイルに対応していません。1タスクごとに1JSファイルがアウトプットされます。
    #
    createWebpackJsTask: (taskName, entries, src, outputDir, outputFileName) ->
      config.jsConcatTaskNames.push taskName

      webpackConfig = Object.assign({
        entry: entries
        output:
          path: outputDir
          filename: "#{outputFileName}.js"
      }, webpackConfigBase)

      # gulp task
      gulp.task taskName, ->
        stream = gulp.src entries
        .pipe gulpPlugins.plumber errorHandler: utils.errorHandler taskName
        .pipe webpackStream webpackConfig, null, (e, stats)->

        return stream.pipe gulp.dest outputDir

      config.optionsWatchTasks.push -> gulpPlugins.watch entries.concat(src), gulp.series(taskName)


    #
    # javascriptのconcatタスクを生成
    #
    # @param {String}       taskName        タスクを識別するための名前 すべてのタスク名と異なるものにする
    # @param {Array|String} src             ソースパス node-globのシンタックスで指定
    # @param {String}       outputDir       最終的に出力されるjsが格納されるディレクトリ
    # @param {String}       outputFileName  最終的に出力されるjsファイル名(拡張子なし)
    #
    createJsConcatTask: (taskName, src, outputDir, outputFileName = 'lib')->
      config.jsConcatTaskNames.push taskName

      gulp.task taskName, ->
        stream = gulp.src src, { allowEmpty: true }
        .pipe gulpPlugins.plumber errorHandler: utils.errorHandler taskName

        if config.sourcemap
          stream = stream
          .pipe gulpPlugins.sourcemaps.init()
          .pipe gulpPlugins.concat "#{outputFileName}.js"
          .pipe gulpPlugins.uglify { output: {comments: 'some'} }
          .pipe gulpPlugins.sourcemaps.write '.'
        else
          stream = stream
          .pipe gulpPlugins.concat "#{outputFileName}.js"
          .pipe gulpPlugins.uglify { output: {comments: 'some'} }

        return stream
        .pipe gulp.dest outputDir
        .pipe gulpPlugins.debug title: gulpPlugins.util.colors.cyan("[#{taskName}]")

      config.optionsWatchTasks.push -> gulpPlugins.watch src, gulp.series(taskName)


    #
    # エラー出力
    #
    errorHandler: (name)-> gulpPlugins.notify.onError title: "#{name} Error", message: '<%= error.message %>'


    #
    # タスク対象のファイル、ディレクトリの配列を生成
    #
    createSrcArr: (name)->
      [].concat config.filePath[name], [
        "!#{config.srcDir}/**/#{config.excrusionPrefix}*"
        "!#{config.srcDir}/**/#{config.excrusionPrefix}*/"
        "!#{config.srcDir}/**/#{config.excrusionPrefix}*/**"
      ]


    #
    # gulpのログの形式でconsole.log
    #
    msg: (msg)->
      d = new Date()
      console.log "[#{gulpPlugins.util.colors.gray(d.getHours() + ':' + d.getMinutes() + ':' + d.getSeconds())}] #{msg}"


    #
    # PostCSS
    #
    postCSS: (stream)->
      postCSSOptions = [ autoprefixer(config.autoprefixerOpt) ]

      if config.minify.css and config.env isnt 'develop'
        postCSSOptions.push require('cssnano')({ autoprefixer: false, zindex: false })

      return stream.pipe gulpPlugins.postcss(postCSSOptions)
