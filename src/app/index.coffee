require './main/'
require '../components/vk-api'
require '../components/popup'

angular.module "vkphotos", ['ui.router', 'vkphotos.main', 'vkphotos.vkapi', 'vkphotos.popup']
.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  $stateProvider
  .state 'home',
    url: '/',
    templateUrl: 'main.html',
    controller: 'MainCtrl'
#  .state 'popup',
#    parent: 'home',
#    url: 'photo/{id:[0-9]+}',
#    templateUrl: 'popup.html',
#    onEnter: ($state) ->
#      console.log($state)
#    controller: ($scope)->
#      console.log $scope.userPhotos
#
#  $locationProvider.html5Mode(true)

  $urlRouterProvider.otherwise('/')
