# elm-third

Third exercise/example/test using Elm.

This time I am embedding an Elm "component" into a Javascript code and I am
using webpack to bundle the compiled code with a JavaScript main file.

## Install and Run

I assume you have Yarn installed. So run:

    yarn install

to dowload all the dependencies.

Most of them are `devDependencies`, since most of the work at runtime is done by Elm and its packages.

We install locally the `elm` system along with two webpack plugins for elm: `elm-webpack-loader` and `elm-hot-webpack-loader` and . They are used during bundling to direct the `.elm` files to the elm compiler.

All the rest are pretty standard packages commonly used when using WebPack (see `package.json`).

The Elm compiler produce javascript tha is bundled along the main Javascript to produce a single `dist/main.js`.

You can compile or run WebPack in watch mode:

    yarn build
    yarn start

With `start` you'll get the demo running on `http://localhost:9393/`.

## The WebPack config and interfacing with Elm

## The Elm app

## Some closing notes...
