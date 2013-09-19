'use strict'

angular.module('rotationApp', ['ui.select2'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/viewfreshmen',
        templateUrl: 'views/viewfreshmen.html',
        controller: 'ViewfreshmenCtrl'
      .otherwise
        redirectTo: '/'
  .factory 'freshmenFactory', () ->
    factory = {}
    # TODO: Make this a PHP call to connect to mysql
    freshmen = [
      {
        name: "Victor Hsu"
        inum: 1301
        house: "Lloyd"
        ranking: 100
      },
      {
        name: "Julie Jester"
        inum: 1303
        house: "Page"
        ranking: 200
      },
      {
        name: "Sean Keenan"
        inum: 1302
        house: "Ruddock"
        ranking: 50
      }
    ]
    factory.getFreshmen = () -> freshmen
    factory