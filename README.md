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

The Elm compiler produces javascript that is bundled along the main Javascript to produce a single `dist/main.js`.

You can compile or run WebPack in watch mode:

    yarn build
    yarn start

With `start` you'll get the demo running on `http://localhost:9393/`.

## The WebPack config and interfacing with Elm

The entry point for the project is JavaScript. We could have an existing App in there and we
could just hook a component built with Elm on a single element of the page.

In our case that's is all we do:

```js
import './main.scss';

import { Elm } from './elm/Main.elm';

const app = Elm.Main.init({
  node: document.getElementById('elm-main')
});
```

Elm can call out JavaScript throuh ports. We don't have any in this project but you can learn how
it is done here https://elmprogramming.com/sending-data-to-javascript.html.



## The Elm app

This app uses the StarWars GraphQL API to download all the Star Wars movies and show them on the
page with some user interaction...

## Some closing notes...
