'use strict';

var webpack = require('webpack');

module.exports  = {
  debug: true,

  entry: './src/app/index.coffee',
  output: {
    filename: "bundle.js"
  },
  module: {
    loaders: [
      { test: /\.html$/, loader: "ng-cache-loader" },
      { test: /\.coffee$/, loader: "coffee-loader" },
      { test: /\.css$/, loader: "style-loader!css-loader" },
      { test: /\.less$/, loader: "style-loader!css-loader!less-loader" }
    ]
  },
  resolve: {
    modulesDirectories: ["web_modules", "node_modules", "bower_components"],
    extensions: ["", ".webpack.js", ".web.js", ".js", ".coffee"]
  },
  plugins: [
    new webpack.ResolverPlugin(
      new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
    )
  ]
};
