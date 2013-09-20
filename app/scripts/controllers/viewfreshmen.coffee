'use strict'

angular.module('rotationApp')
  .controller 'ViewfreshmenCtrl', ($scope, freshmenFactory) ->
    $scope.freshmen = freshmenFactory.getFreshmen()

    $scope.findFreshmen = (inum) ->
      _.findWhere($scope.freshmen, {"inum": parseInt(inum)})

    $scope.displayMode = {model: 'simple'}
    $scope.displayModeValues = ['simple', 'full', 'lloyd']
    $scope.tableCols = ['inum', 'name']

    $scope.setCols = (key) ->
      switch (key)
        when 'simple' then $scope.tableCols = ['inum', 'name']
        when 'full' then $scope.tableCols = ['inum', 'name', 'house', 'ranking']
        when 'lloyd' then $scope.tableCols = ['inum', 'name', 'ranking']
        else $scope.tableCols = ['inum', 'name']
