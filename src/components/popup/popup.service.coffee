module.exports = ($compile) ->
  elemCompile = $compile(angular.element('<popup></popup>'))

  {
    open: ($scope) ->
      elemCompile($scope)
      return
  }
