import './main.scss';

import { Elm } from './elm/Main.elm';

const app = Elm.Main.init({
  node: document.getElementById('elm-main')
});

console.log('Eml is here?');