// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require jquery3
//= require popper
//= require bootstrap

import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import * as noUiSlider from 'nouislider';
import 'nouislider/dist/nouislider.css';
require("jquery")
require("suggestions-jquery")
import "controllers"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// importAll(require.context("../../assets/javascripts/", true, /\.js$/))

// function importAll(r) {
//   r.keys().forEach(r);
// }

require("trix")
require("@rails/actiontext")