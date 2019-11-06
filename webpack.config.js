const path = require('path');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const rootpath = process.cwd();
const src = path.join(rootpath, 'src' );
const dst = path.join(rootpath, 'dist' );
const elmSource = path.join(rootpath, 'src', 'elm');
const pathToElm = path.join(rootpath, 'node_modules', '.bin', 'elm');

const miniCssExtract = new MiniCssExtractPlugin({
  filename: "[name].css",
})

const wpPlugins = [
  miniCssExtract,
];

module.exports = {
  mode: 'development',

  entry: {
    main: path.join(src, 'main.js')
  },

  output: {
    filename: 'main.js',
    path: dst,
  },

  plugins: wpPlugins,

  devServer: {
    contentBase: path.join(rootpath,'dist'),
    port:9393,
    open: false,
    overlay: true,
    openPage: 'index.html',
    inline: true,
    index: 'index.html',
    historyApiFallback: true,
    disableHostCheck: true
  },

  module: {
    rules: [
      {
        test: /\.(scss|sass|css)$/,
        use: [
          'style-loader',
          MiniCssExtractPlugin.loader,
          {
            loader: "css-loader",
            options: {
              import: true,
              sourceMap: true
            }
          },
					{
						loader: "sass-loader"
					}
				]
      },
      {
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      use: [
        {
          loader: 'elm-hot-webpack-loader'
        },
        {
          loader: 'elm-webpack-loader',
          options: {
            pathToElm,
            maxInstances: 4
          }
        }
      ]
    }]
  }
}
