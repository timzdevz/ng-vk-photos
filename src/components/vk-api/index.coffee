VKApiService = require './vk-api.coffee'

module.exports = angular.module 'vkphotos.vkapi', []
.constant('VK_API_KEY', 4784531)
.factory 'VKApi', ['$q', 'VK_API_KEY', VKApiService]
