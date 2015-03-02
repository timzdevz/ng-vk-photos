module.exports = ($scope, $state, $q, VKApi, PhotoPopup, orderByFilter) ->
  PHOTOS_PER_PAGE = 50

  # user id or screen name
  $scope.userIdInput = ''

  # user id (int)
  $scope.ownerId = 0

  $scope.statusMessage = ''
  $scope.userPhotos = null;
  $scope.sortBy = '-created'
  $scope.loadingNext = $scope.loadedAll = false

  $scope.$on('popupOpened', ->
    $scope.popupOpened = true
  )

  $scope.$on('popupClosed', ->
    $scope.popupOpened = false
  )

  $scope.sortPhotos = (sortBy) ->
    $scope.userPhotos = orderByFilter($scope.userPhotos, sortBy)

  $scope.getPhotos = (userId) ->
    deferred = $q.defer()

    $scope.userPhotos = []
    $scope.ownerId = 0
    $scope.loadingNext = $scope.loadedAll = false;
    $scope.statusMessage = 'Loading data...'

    VKApi.auth().then(
      ->
        VKApi.getUser(userId).then((ownerId) ->
          if ownerId?
            $scope.ownerId = ownerId
            VKApi.getWallPhotos($scope.ownerId, PHOTOS_PER_PAGE).then (response) ->
              if (response.length == 0)
                $scope.statusMessage = 'Photos not found.'
                deferred.reject()
              else
                deferred.resolve()
                $scope.userPhotos = response
                $scope.statusMessage = ''
          else
            deferred.reject()
            $scope.statusMessage = 'User not found.'
            $scope.userIdInput = ''
          return
        )
    , ->
      $scope.statusMessage = 'You have to login to use VK API.';
    )

    return deferred.promise

  $scope.getNextPhotos = (photoCount = PHOTOS_PER_PAGE, offset = $scope.userPhotos.length) ->
    if photoCount <= 0
      return

    if $scope.userPhotos.length < PHOTOS_PER_PAGE
      $scope.loadedAll = true
      $state.go('user.params', { offset: '' }, location: 'replace')
      return

    $scope.loadingNext = true

    VKApi.getWallPhotos($scope.ownerId, photoCount, offset).then (response) ->

      if response.length != 0
        $scope.userPhotos = $scope.userPhotos.concat(response)

      else if response.length < PHOTOS_PER_PAGE or response.length == 0
        $scope.loadedAll = true

      $scope.loadingNext = false

      # we don't want to set offset=0
      if not ($scope.loadedAll and $scope.userPhotos.length == PHOTOS_PER_PAGE)
        $state.go('user.params', { offset: $scope.userPhotos.length - PHOTOS_PER_PAGE}, location: 'replace')

      # uncomment to enable sort filter after new data has been fetched
      # $scope.userPhotos = orderByFilter($scope.userPhotos, $scope.sortBy)

  $scope.openPopup = (photoId, photoIndex) ->

    if not photoIndex?
      $scope.userPhotos.every((element, index) ->
        if (element.pid == photoId)
          photoIndex = index
          return false

        return true
      )

    if photoIndex >= 0
      $state.go('user.params', { photo: photoId }, location: 'replace')
      PhotoPopup.open($scope, photoIndex)
    else
      $state.go('user.params', { photo: '' }, location: 'replace')

  $scope.formSubmit = ->

    $stateParams =
      location: 'replace',
      inherit: false

    if ($state.current.name == 'user.params')
      $scope.getPhotos($scope.userIdInput)

    $state.go('user.params', {
      id: $scope.userIdInput,
    }, $stateParams)
