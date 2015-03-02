require './main/'

angular.module "vkphotos", ['ui.router', 'vkphotos.main']
.config ['$stateProvider', '$urlRouterProvider', '$locationProvider', ($stateProvider, $urlRouterProvider, $locationProvider) ->

  $stateProvider
  .state 'home',
    url: '/',
    templateUrl: 'main.html',
    controller: 'MainCtrl'

  .state 'user',
    url: 'user',
    parent: 'home',
    abstract: true,
    templateUrl: 'photo-list.html',
    controller: ($scope, $state) ->
      offset = parseInt($state.params.offset)
      photoId = parseInt($state.params.photo)

      $scope.getPhotos($state.params.id).then ->
        if offset == +$state.params.offset
          $scope.getNextPhotos(offset)

      .then ->
        if photoId == +$state.params.photo
          $scope.openPopup(photoId)

      $scope.$parent.$on 'popupClosed', ->
        $state.go('user.params', { photo: ''}, location: 'replace')

      $scope.$parent.$on 'popupPhotoChanged', (event, photoId) ->
        $state.go('user.params', { photo: photoId}, location: 'replace')

  .state 'user.params',
    url: '/{id:[^/]+}?offset?photo'

  $urlRouterProvider.otherwise('/')
  $locationProvider.html5Mode(true)
]
