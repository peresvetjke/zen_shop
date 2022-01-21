const { environment } = require('@rails/webpacker')

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

module.exports = environment
