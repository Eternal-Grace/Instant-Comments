import colors from 'vuetify/es5/util/colors'
import minifyTheme from 'minify-css-string'
import { fr } from 'vuetify/src/locale'

export default {
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    titleTemplate: `%s - ${process.env.SITE_NAME}`,
    title: process.env.SITE_NAME,
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' }
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
    script: [{ src: `${process.env.BASE_URL}/socket.io/socket.io.js` }]
  },

  // HTTP2
  render: {
    asyncScripts: true,
    crossorigin: 'anonymous',
    http2: {
      push: true,
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      pushAssets: (req, res, publicPath, preloadFiles) =>
        preloadFiles
          .filter((f) => f.asType === 'script' && f.file === 'runtime.js')
          .map((f) => `<${publicPath}${f.file}>;rel=prefetch;as=${f.asType}`)
    }
  },

  // Server configuration.
  server: {
    port: process.env.PORT || 3000,
    host: process.env.HOST || '0.0.0.0',
    timing: false,
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [
    '@fortawesome/fontawesome-free/css/all.css',
  ],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    { src: '~/plugins/filters' },
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: ['~/components'],

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/typescript
    '@nuxt/typescript-build',
    // https://go.nuxtjs.dev/stylelint
    '@nuxtjs/stylelint-module',
    // https://go.nuxtjs.dev/vuetify
    '@nuxtjs/vuetify',
    // https://marquez.co/docs/nuxt-optimized-images/configuration
    '@aceforth/nuxt-optimized-images',
    // https://github.com/nuxt-community/laravel-echo-module
    '@nuxtjs/laravel-echo',
  ],

  // Styleline: https://go.nuxtjs.dev/stylelint
  stylelint: {
    fix: true,
    files: [
      'assets/styles/**/*.scss',
      '{components,component,layouts,pages}/**/*.vue'
    ]
  },

  // VueJS module configuration: ...
  vue: {
    config: {
      productionTip: true,
      devtools: true,
    },
  },
  // Vuetify module configuration: https://go.nuxtjs.dev/config-vuetify
  vuetify: {
    lang: {
      locales: { fr },
      current: 'en'
    },
    defaultAssets: false,
    icons: {
      iconfont: 'fa',
    },
    theme: {
      options: { minifyTheme },
      dark: false,
      themes: {
        dark: {
          primary: colors.grey.darken2,
          accent: colors.grey.darken4,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.darken3,
          error: colors.deepOrange.darken2,
          success: colors.green.base
        }
      }
    }
  },

  optimizedImages: {
    optimizeImages: true
  },

  echo: {
    broadcaster: 'socket.io',
    authEndpoint: '/api/broadcasting/auth',
    host: process.env.BASE_URL,
    encrypted: true,
    authModule: true,
    connectOnLogin: true,
    disconnectOnLogout: true,
    transports: ['websocket', 'polling'],
    auth: {
      headers: {
        Accept: 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      }
    }
  },

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    // https://go.nuxtjs.dev/pwa
    '@nuxtjs/pwa',
    // https://go.nuxtjs.dev/content
    '@nuxt/content',
    // https://i18n.nuxtjs.org
    '@nuxtjs/i18n',
  ],

  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    proxy: true,
    proxyHeaders: false,
    credentials: true,
    debug: process.env.NODE_ENV === 'development',
    retry: { retries: 3, retryDelay: () => 200 },
    headers: {
      common: {
        Accept: 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      }
    }
  },
  proxy: {
    '/socket.io/': {
      ws: true,
      target: process.env.URL_SOCKET
    },
    '/api/': {
      ws: false,
      target: process.env.URL_BACKEND
    },
    // Must change to CDN.
    '/data/': {
      ws: false,
      target: process.env.URL_BACKEND,
      pathRewrite: {
        '^/data': '/storage/'
      }
    }
  },

  // PWA module configuration: https://go.nuxtjs.dev/pwa
  pwa: {
    manifest: {
      lang: 'en'
    }
  },

  // Content module configuration: https://go.nuxtjs.dev/config-content
  content: {},

  // i18n module configuration: https://i18n.nuxtjs.org
  i18n: {
    lazy: true,
    baseUrl: process.env.BASE_URL,
    langDir: './locales/',
    locales: [
      { code: 'en', iso: 'en-GB', file: 'en.json' },
      { code: 'fr', iso: 'fr-FR', file: 'fr.json' },
    ],
    defaultLocale: 'en',
    strategy: 'prefix',
    detectBrowserLanguage: {
      useCookie: true,
      fallbackLocale: 'en',
      onlyOnRoot: true,
      cookieKey: '__ic_lang',
      cookieSecure: process.env.NODE_ENV === 'production'
    },
    vuex: {
      moduleName: 'lang',
      syncLocale: true
    }
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
    followSymlinks: false,
    fallback: true,
    transpile: ['vuetify/lib'],
    cssSourceMap: true,
    extractCSS: true,
    extend(config, { isDev, isClient }) {
      if (isClient) {
        config.optimization.splitChunks.maxSize = 200000
      }
      if (isDev && isClient) {
        config.devtool = 'eval-source-map'
      }
    },
    splitChunks: {
      layouts: true,
      pages: true,
      commons: true
    }
  },

  // Telemetry disabled
  telemetry: false
}
