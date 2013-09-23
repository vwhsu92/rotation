'use strict'

angular.module('rotationApp')
  .controller 'HeaderCtrl', ($scope, $location) ->

    $scope.isActive = (viewRoute) ->
      viewRoute == $location.path()
