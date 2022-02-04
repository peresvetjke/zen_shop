// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require jquery3
//= require popper
//= require bootstrap

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import * as noUiSlider from 'nouislider';
import 'nouislider/dist/nouislider.css';
require("jquery")
require("suggestions-jquery")

Rails.start()
Turbolinks.start()
ActiveStorage.start()

importAll(require.context("../../assets/javascripts/", true, /\.js$/))

function importAll(r) {
  r.keys().forEach(r);
}

// Vue js
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import CategoriesList from '../components/categories-list.vue'
import Category from '../components/category.vue'
import Errors from '../components/errors.vue'
import Message from '../components/message.vue'
import ItemsList from '../components/items-list.vue'
import Item from '../components/item.vue'
import SearchFilter from '../components/search-filter.vue'
import SearchFilterCategoriesList from '../components/search-filter/search-filter-categories-list.vue'
import SearchFilterCategory from '../components/search-filter/search-filter-category.vue'
import SearchFilterPrice from '../components/search-filter/search-filter-price.vue'

Vue.use(TurbolinksAdapter)

Vue.component('categories-list', CategoriesList)
Vue.component('category', Category)
Vue.component('errors', Errors)
Vue.component('message', Message)
Vue.component('items', ItemsList)
Vue.component('item', Item)
Vue.component('search-filter', SearchFilter)
Vue.component('search-filter-categories', SearchFilterCategoriesList)
Vue.component('search-filter-category', SearchFilterCategory)
Vue.component('search-filter-price', SearchFilterPrice)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: `[data-behavior='vue']`,
    components: { 
      Category, CategoriesList, ItemsList, Item, Errors, Message,
      SearchFilter, SearchFilterCategoriesList, SearchFilterCategory, SearchFilterPrice
    }
  })
})

require("trix")
require("@rails/actiontext")