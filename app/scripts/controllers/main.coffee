'use strict'

angular.module('rotationApp')
  .controller 'MainCtrl', ($scope, freshmenFactory) ->
  	$scope.freshmen = freshmenFactory.getFreshmen()
  	$scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJSidasda'
      'Karma'
    ]
