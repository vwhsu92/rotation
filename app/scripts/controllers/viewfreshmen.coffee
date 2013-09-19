'use strict'

angular.module('rotationApp')
  .controller 'ViewfreshmenCtrl', ($scope, freshmenFactory) ->
    $scope.freshmen = freshmenFactory.getFreshmen()
    $scope.findFreshmen = (inum) ->
      _.findWhere($scope.freshmen, {"inum": parseInt(inum)})
