const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

const path = require('path');

const webpack = require('webpack')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Handlebars: 'handlebars',
    noUiSlider: 'nouislider'
  })
)

environment.loaders.prepend('Handlebars', {
  test: /\.hbs$/,
  use: {
    loader: 'handlebars-loader',
    query: {
      knownHelpersOnly: false,
      helperDirs: [ path.resolve(__dirname, "../../app/assets/handlebars/helpers/") ],
      templateDirs: [ path.resolve(__dirname, "../../app/assets/handlebars/partials") ]
    }
  }
});

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
