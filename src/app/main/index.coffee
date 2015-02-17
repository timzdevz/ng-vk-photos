
require 'normalize.css'
MainCtrl = require './main.controller'
require './main.html'
require './main.less'

module.exports = angular.module "vkphotos.main", ['infinite-scroll']
.controller "MainCtrl", MainCtrl
