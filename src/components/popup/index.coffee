photoPopupDirective = require './popup.directive'
photoPopupService = require './popup.service'
require './popup.html'
require './popup.less'

module.exports = angular.module 'vkphotos.popup', []
.service 'PhotoPopup', ['$compile', photoPopupService]
.directive 'popup', photoPopupDirective
