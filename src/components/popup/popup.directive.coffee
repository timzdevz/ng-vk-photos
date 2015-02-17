module.exports = ($compile) ->
  {
  templateUrl: 'popup.html'
  restrict: 'E'
  replace: true,
  link: (scope, elem) ->
    scope.elem = elem

    scope.onKeyDown = (event) ->
      console.log event

      if event.which == 27 # escapekey
        scope.close()
      else if event.which == 37 # left arrow
        scope.prevPhoto()
      else if event.which == 39 # right arrow
        scope.nextPhoto()

      event.preventDefault()

    body = angular.element(document.body)
    body.append(elem[0])

    body.bind('keydown', scope.onKeyDown)

  controller: ($scope) ->
    $scope.photo = $scope.userPhotos[$scope.currentPhotoIndex]

    $scope.close = ->
      angular.element(document.body).unbind('keydown', $scope.onKeyDown)
      $scope.elem.remove()
      return

    $scope.nextPhoto = ->
      if ++$scope.currentPhotoIndex > $scope.userPhotos.length-1
        $scope.currentPhotoIndex = 0;

      $scope.photo = $scope.userPhotos[$scope.currentPhotoIndex]
      if(!$scope.$$phase)
        $scope.$apply()

    $scope.prevPhoto = ->
      if --$scope.currentPhotoIndex < 0
        $scope.currentPhotoIndex = $scope.userPhotos.length-1;

      $scope.photo = $scope.userPhotos[$scope.currentPhotoIndex]
      if(!$scope.$$phase)
        $scope.$apply()
  }
