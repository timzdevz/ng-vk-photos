module.exports = ($q) ->
  VK.init {apiId: 4784531}
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
          console.log 'user rejected authentication'
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

  userExists = (userId)  ->
    deferred = $q.defer()

    VK.Api.call 'users.get',
      {
        user_ids: userId,
      },
      (data) ->
        exists = true
        if data.error && data.error['error_code'] == 113 or
            data.response && data.response[0].deactivated
          exists = false;

        deferred.resolve(exists)

    deferred.promise

  getWallPhotos = (userId, offset = 0) ->
    deferred = $q.defer()

    VK.Api.call 'photos.getProfile',
      {
        owner_id: userId,
        count: 50,
        extended: 1,
        photo_sizes: 1,
        offset: offset
      },
      (data) ->
        deferred.resolve(data.response)

    deferred.promise

  return {
    auth: auth
    userExists: userExists
    getWallPhotos: getWallPhotos
  }
