'use strict'

angular.module('rotationApp', ['ui.bootstrap.buttons', 'ui.keypress', 'ui.select2'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/viewfreshmen',
        templateUrl: 'views/viewfreshmen.html',
        controller: 'ViewfreshmenCtrl',
        reloadOnSearch: false
      .when '/querytable',
        templateUrl: 'views/querytable.html',
        controller: 'QuerytableCtrl',
        reloadOnSearch: false
      .when '/assignhouse',
        templateUrl: 'views/assignhouse.html',
        controller: 'AssignhouseCtrl',
        reloadOnSearch: false
      .when '/monitor',
        templateUrl: 'views/monitor.html',
        controller: 'MonitorCtrl'
        reloadOnSearch: false
      .otherwise
        redirectTo: '/'
  .factory 'freshmenFactory', ($http, $q) ->
    factory = {}
    phpSource = 'http://lloyd.caltech.edu/rotation/test.php'

    factory.getFreshmen = () ->
      deferred = $q.defer()
      freshmen = []

      $http.post(phpSource, {})
        .success((data, status) ->
            freshmen = data;
            deferred.resolve(freshmen);
        )
        .error((data, status) ->
            console.log "Freshmen factory failed to receive data"
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
  .factory 'imageLocationFactory', () ->
    factory = 
      imageFolder: 'http://lloyd.caltech.edu/meetings/photos2013/'
    factory