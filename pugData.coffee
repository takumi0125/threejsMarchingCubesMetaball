config =
  default:
    siteUrl: 'https://takumi0125.github.io/threejsMarchingCubesMetaball/'
    keywords: ''

    showOGP: true # ogpタグを表示するかどうか

    # author: ''
    # copyright: ''

    siteTitle: 'three.js Marching Cubes Metaball'
    useTitleAsOgTitle: true # ogTitleをtitleと同じにするかどうか
    ogTitle: ''
    useTitleSeparater: true
    titleSeparater: ' | '

    description: "WebGL Marching Cubes Metaball powered by three.js"
    useDescriptionAsOgDescription: true # ogDescriptionをdescriptionと同じにするかどうか
    ogDescription: ""

    # fbAppId: ''

    ogSiteName: 'sample'

    ogImage: 'https://takumi0125.github.io/threejsMarchingCubesMetaball/assets/img/ogp.jpg'
    ogImageType: 'image/jpeg'
    ogImageWidth: '1200'
    ogImageHeight: '630'

    ogType: 'website'
    ogLocale: 'ja_JP'

    showTwitterCard: true # twitterCardを表示するかどうか
    twitterCardType: 'summary_large_image'
    useOgAsTwitterCard: true # twitterCardの各値をogの各値と同じにするかどうか
    twitterCardTitle: ''
    twitterCardDesc: ''
    twitterCardImg: ''

    favicons:
      default: './assets/img/icon/favicon.ico'
      # "96x96": '/assets/img/icon/favicon-96.png'
      # "192x192": '/assets/img/icon/favicon-192.png'

    appleTouchIcons:
      default: './assets/img/icon/apple-touch-icon.png'
      # "57x57"  : '/assets/img/icon/apple-touch-icon-57.png'
      # "60x60"  : '/assets/img/icon/apple-touch-icon-60.png'
      # "72x72"  : '/assets/img/icon/apple-touch-icon-72.png'
      # "76x76"  : '/assets/img/icon/apple-touch-icon-76.png'
      # "114x114": '/assets/img/icon/apple-touch-icon-114.png'
      # "120x120": '/assets/img/icon/apple-touch-icon-120.png'
      # "144x144": '/assets/img/icon/apple-touch-icon-144.png'
      # "152x152": '/assets/img/icon/apple-touch-icon-152.png'
      # "180x180": '/assets/img/icon/apple-touch-icon-180.png'

    manifestJson: './assets/img/icon/manifest.json'

    themeColor: '#ffffff'

    maskIcon:
      svg: ''
      color: '#000000'

    msAppTitleColor: '#ffffff'

  develop:
    siteUrl: 'https://takumi0125.github.io/threejsMarchingCubesMetaball/'
    ogImage: 'https://takumi0125.github.io/threejsMarchingCubesMetaball/assets/img/ogp.jpg'

  staging:
    siteUrl: 'https://takumi0125.github.io/threejsMarchingCubesMetaball/'
    ogImage: 'https://takumi0125.github.io/threejsMarchingCubesMetaball/assets/img/ogp.jpg'

  production:
    siteUrl: 'https://takumi0125.github.io/threejsMarchingCubesMetaball/'
    ogImage: 'https://takumi0125.github.io/threejsMarchingCubesMetaball/assets/img/ogp.jpg'


module.exports = (env) ->
  data = config.default
  data.env = env
  for key, value of config[env]
    data[key] = value
  return data
