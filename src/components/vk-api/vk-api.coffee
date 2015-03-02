module.exports = ($q, VK_API_KEY) ->
  PHOTO_REQUEST_LIMIT = 1000

  VK.init {apiId: VK_API_KEY}
  authed = false

  auth = ->
    deferred = $q.defer();

    isAuth().then(->
      deferred.resolve()
    , () ->
      VK.Auth.login((response) ->
        if (response.session)
          deferred.resolve()
        else
          deferred.reject()
      )
    )

    deferred.promise

  isAuth = ->
    deferred = $q.defer()

    if authed
      deferred.resolve()

    VK.Auth.getLoginStatus((response) ->
      if(response.session)
        authed = true
        deferred.resolve()
      else
        deferred.reject()
    )

    deferred.promise

  getUser = (userId)  ->
    deferred = $q.defer()

    VK.Api.call 'users.get',
      {
        user_ids: userId,
      },
      (data) ->
        if data.error && data.error['error_code'] == 113 or
            data.response && data.response[0].deactivated
          ownerId = null;
        else
          ownerId = data.response[0].uid

        deferred.resolve(ownerId)

    deferred.promise

  getWallPhotos = (userId, count, offset = 0) ->
    deferred = $q.defer()

    if(count > PHOTO_REQUEST_LIMIT)
      console.info 'Requests are limited to ' + PHOTO_REQUEST_LIMIT + 'photos!'
      count = PHOTO_REQUEST_LIMIT

    VK.Api.call 'photos.get',
      {
        owner_id: userId,
        album_id: 'wall',
        count: count,
        rev: 1,
        extended: 1,
        photo_sizes: 1,
        offset: offset
      },
      (data) ->
        deferred.resolve(data.response)

    deferred.promise

  return {
    auth: auth
    getUser: getUser
    getWallPhotos: getWallPhotos
  }
