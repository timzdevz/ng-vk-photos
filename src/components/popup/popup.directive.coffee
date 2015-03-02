module.exports = ->
  templateUrl: 'popup.html'
  restrict: 'E'
  replace: true,
  scope: true,
  link: (scope, elem, attrs) ->
    scope.elem = elem

    # set popup photo
    scope.currentPhotoIndex = +attrs.photoIndex
    scope.photo = scope.userPhotos[scope.currentPhotoIndex]

    # position popup relatively to current scroll top
    scrollTop = (document.documentElement.scrollTop || document.body.scrollTop)
    popupElem = angular.element(elem[0].querySelector('.popup-photo'))
    popupElem.css('top', scrollTop + 'px')

    # set keyDown event handler
    scope.onKeyDown = (event) ->
      if event.which == 27 # escapekey
        scope.close()
      else if event.which == 37 # left arrow
        scope.prevPhoto()
      else if event.which == 39 # right arrow
        scope.nextPhoto()

    body = angular.element(document.body)
    body.bind('keydown', scope.onKeyDown)

    body.append(elem[0])

    scope.$emit('popupOpened')

  controller: ['$scope', ($scope) ->
    $scope.close = ->
      angular.element(document.body).unbind('keydown', $scope.onKeyDown)
      $scope.elem.remove()
      $scope.$emit('popupClosed')
      return

    $scope.nextPhoto = ->
      if ++$scope.currentPhotoIndex > $scope.userPhotos.length - 1
        $scope.currentPhotoIndex = 0;

      $scope.photo = $scope.userPhotos[$scope.currentPhotoIndex]
      $scope.$emit('popupPhotoChanged', $scope.photo.pid)
      if(!$scope.$$phase)
        $scope.$apply()

    $scope.prevPhoto = ->
      if --$scope.currentPhotoIndex < 0
        $scope.currentPhotoIndex = $scope.userPhotos.length - 1;

      $scope.photo = $scope.userPhotos[$scope.currentPhotoIndex]
      $scope.$emit('popupPhotoChanged', $scope.photo.pid)
      if(!$scope.$$phase)
        $scope.$apply()
  ]
