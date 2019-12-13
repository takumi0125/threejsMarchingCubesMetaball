##############
### config ###
##############

_PROJECT_DIR = __dirname.replace(/\/gulp$/, '').replace(/\\gulp$/, '')

_SRC_DIR = "#{_PROJECT_DIR}/src"

_PUBLISH_DIR = "#{_PROJECT_DIR}/docs"

_EXCRUSION_PREFIX = '_'

_IMG_DIR_NAME = '{img,image,images}'

_TARGET_BROWSERS = [ 'last 2 versions', 'ie >= 10', 'Android >= 4.4', 'iOS >= 10' ]

config =
  # プロジェクト名
  projectName: 'marchingCubes'

  # ソースディレクトリ
  srcDir: _SRC_DIR

  # 納品ディレクトリ
  publishDir: _PUBLISH_DIR

  # ローカルサーバのデフォルトパス (ドキュメントルートからの絶対パス)
  serverDefaultPath: '/'

  # ローカルサーバをhttpsにするかどうか
  https: false

  # タスクから除外するためのプレフィックス
  excrusionPrefix: _EXCRUSION_PREFIX

  # ターゲットブラウザ
  targetBrowsers: _TARGET_BROWSERS

  # gulpPlugins.autoprefixerのオプション
  autoprefixerOpt:
    overrideBrowserslist: _TARGET_BROWSERS
    grid: true

  # assetsディレクトリへドキュメントルートからの相対パス
  assetsDir: 'assets'

  # 画像ディレクトリの名前
  imgDirName: _IMG_DIR_NAME

  # ファイル圧縮
  minify:
    # CSSを圧縮するかどうか
    css: true

    # JSを圧縮するかどうか
    js: true

    # HTMLを圧縮するかどうか (pugのみ)
    html: false

  # pugで読み込むjsonファイル
  pugData: "#{_PROJECT_DIR}/pugData.coffee"

  # JS設定ファイル
  jsEnv: "#{_SRC_DIR}/assets/js/#{_EXCRUSION_PREFIX}env.js"

  # _PUBLISH_DIR内のclean対象のディレクトリ (除外したいパスがある場合にnode-globのシンタックスで指定)
  clearDir: [
    "#{_PUBLISH_DIR}/**/*"
    "!#{_PUBLISH_DIR}"
  ]

  # 各種パス
  filePath:
    html    : "#{_SRC_DIR}/**/*.html"
    pug     : "#{_SRC_DIR}/**/*.{pug,jade}"
    css     : "#{_SRC_DIR}/**/*.css"
    sass    : "#{_SRC_DIR}/**/*.{sass,scss}"
    js      : "#{_SRC_DIR}/**/*.{js,jsx,vue}"
    json    : "#{_SRC_DIR}/**/*.json"
    json5   : "#{_SRC_DIR}/**/*.json5"
    coffee  : "#{_SRC_DIR}/**/*.coffee"
    cson    : "#{_SRC_DIR}/**/*.cson"
    img     : [
      "#{_SRC_DIR}/**/#{_IMG_DIR_NAME}/**"
      "!#{_SRC_DIR}/**/font/**"
    ]
    others  : [
      "#{_SRC_DIR}/**/*"
      "#{_SRC_DIR}/**/.htaccess"
      "!#{_SRC_DIR}/**/*.{html,pug,jade,css,sass,scss,js.jsx,vue,json,coffee,cson,md,map}"
      "!#{_SRC_DIR}/**/#{_IMG_DIR_NAME}/**"
    ]
    pugInclude: [
      "#{_SRC_DIR}/**/#{_EXCRUSION_PREFIX}*/**/*.pug"
      "#{_SRC_DIR}/**/#{_EXCRUSION_PREFIX}*.pug"
      "#{_SRC_DIR}/**/#{_EXCRUSION_PREFIX}*/**/*.jade"
      "#{_SRC_DIR}/**/#{_EXCRUSION_PREFIX}*.jade"
    ]
    sassInclude: [
      "#{_SRC_DIR}/**/#{_EXCRUSION_PREFIX}*/**/*.{sass,scss}"
      "#{_SRC_DIR}/**/#{_EXCRUSION_PREFIX}*.{sass,scss}"
    ]

module.exports = config
