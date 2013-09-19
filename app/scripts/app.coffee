'use strict'

angular.module('rotationApp', [])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
  .factory 'freshmenFactory', () ->
    factory = {}
    # TODO: Make this a PHP call to connect to mysql
    freshmen = [{"name": "Victor"}, {"name": "Sean"}]
    factory.getFreshmen = () -> freshmen
    factory