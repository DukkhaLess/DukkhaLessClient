'use strict'

const path = require('path')
const webpack = require('webpack')
const isWebpackDevServer = process.argv.some(
  a => path.basename(a) === 'webpack-dev-server'
)

const isWatch = process.argv.some(a => a === '--watch')

const plugins =
  isWebpackDevServer || !isWatch
    ? []
    : [
        function() {
          this.plugin('done', function(stats) {
            process.stderr.write(stats.toString('errors-only'))
          })
        }
      ]

const mode = process.env.NODE_ENV || 'development'

module.exports = {
  devtool: 'eval-source-map',

  devServer: {
    contentBase: '.',
    port: 4008,
    stats: 'errors-only'
  },

  mode,

  entry: './src/Main.purs',

  output: {
    path: __dirname + '/dist/static',
    pathinfo: true,
    filename: 'app.js'
  },

  module: {
    rules: [
      {
        test: /\.purs$/,
        use: [
          {
            loader: 'purs-loader',
            options: {
              src: ['src/**/*.purs'],
              bundle: false,
              spago: true,
              watch: isWebpackDevServer || isWatch
            }
          }
        ]
      }
    ]
  },

  resolve: {
    modules: ['node_modules'],
    extensions: ['.purs', '.js']
  },

  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: true
    })
  ].concat(plugins)
}
