'use strict'

angular.module('rotationApp', ['ui.bootstrap.buttons', 'ui.select2'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/viewfreshmen',
        templateUrl: 'views/viewfreshmen.html',
        controller: 'ViewfreshmenCtrl',
        reloadOnSearch: false
      .otherwise
        redirectTo: '/'
  .factory 'freshmenFactory', ($http, $q) ->
    factory = {}
    phpSource = 'http://lloyd.caltech.edu/rotation/test.php'

    factory.getFreshmen = () ->
      deferred = $q.defer()
      freshmen = []

      $http.post(phpSource, { "data" : "hi"})
        .success((data, status) ->
            freshmen = data;
            deferred.resolve(freshmen);
        )
        .error((data, status) ->
            deferred.resolve(freshmen);
        )

      ### TEST DATA IF NO PHP/SQL DATASOURCE
        freshmen = [
          {
            name: "Victor Hsu"
            inum: 7590
            house: "Lloyd"
            ranking: 100
          },
          {
            name: "Julie Jester"
            inum: 7950
            house: "Page"
            ranking: 200
          },
          {
            name: "Sean Keenan"
            inum: 7960
            house: "Ruddock"
            ranking: 50
          }
        ]
        deferred = $q.defer()
        deferred.resolve(freshmen)
      ###

      deferred.promise
    factory