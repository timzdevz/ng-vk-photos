module.exports = ($compile) ->
  {
    open: (scope, photoIndex) ->
      $compile(angular.element('<popup photo-index="' + photoIndex + '"></popup>'))(scope)
      return
  }
