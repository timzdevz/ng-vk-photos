module.exports = ($scope, VKApi, PhotoPopup, orderByFilter) ->
  $scope.userId = $scope.statusMessage = ''
  $scope.userPhotos = null;
  $scope.sortBy = '-created'
  $scope.currentPhotoIndex = 0

  $scope.sortPhotos = (sortBy) ->
    $scope.userPhotos = orderByFilter($scope.userPhotos, sortBy)

  $scope.test = ->
    console.log 'test'

  $scope.getPhotos = ->
    $scope.statusMessage = 'Loading data...'
    $scope.userPhotos = []

    VKApi.auth().then(
      ->
        VKApi.userExists($scope.userId).then((exists)->
          if exists
            VKApi.getWallPhotos($scope.userId).then (response) ->
              if (response.length == 0)
                $scope.statusMessage = 'Photos not found.'
              else
                $scope.userPhotos = orderByFilter(response, $scope.sortBy)
                $scope.statusMessage = ''
          else
            $scope.statusMessage = 'User not found.'
            $scope.userId = ''
          return
        )
    , ->
        $scope.statusMessage = 'You have to login to use VK API.';
    )

    $scope.openPopup = (photoIndex) ->
      $scope.currentPhotoIndex = photoIndex
      PhotoPopup.open($scope)
