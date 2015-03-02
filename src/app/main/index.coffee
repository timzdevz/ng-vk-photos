MainCtrl = require './main.controller'
require '../../components/vk-api'
require '../../components/popup'

require 'normalize.css'
require './main.html'
require './main.less'
require './photo-list.html'

module.exports = angular.module "vkphotos.main", ['infinite-scroll', 'vkphotos.vkapi', 'vkphotos.popup']
.controller "MainCtrl", ['$scope', '$state', '$q', 'VKApi', 'PhotoPopup', 'orderByFilter', MainCtrl]
