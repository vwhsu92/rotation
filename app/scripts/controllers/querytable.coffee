'use strict'

angular.module('rotationApp')
  .controller 'QuerytableCtrl',  ($scope, $routeParams, $location, $http, $q) ->

    phpSource = 'http://lloyd.caltech.edu/rotation/query.php'

    ###
    Functions
    ###

    # Checks if inum is a returned table column to show picture
    $scope.hasInum = () ->
      _.contains($scope.data.tableCols, 'inum')

    # Handler called when the show images checkbox is checked
    $scope.changeShowImages = () ->
      updatePath()

    # Handler called when the Run Query button is clicked
    $scope.clickRunQuery = () ->
      executeSqlStatement()
      updatePath()

    # Handler to let you push enter to run query
    $scope.enterKeyCallback = (e) ->
      $scope.clickRunQuery()

    # Handler to nicely close warning dialog
    $scope.clickCloseWarning = () ->
      $("#warning-div").slideUp()

    # Checks SQL statement and gets db data from PHP
    executeSqlStatement = () ->
      $scope.data.runDisabled = true
      statement = $scope.data.sqlQuery
      $("#results-table").hide()

      # Check SQL statement before sending request to PHP
      if statement[statement.length - 1] != ';'
        $("#warning-msg").html("Statement must end in a semicolon")
        $("#warning-div").slideDown()
        return
      else if statement.toUpperCase().indexOf("SELECT") != 0 
        $("#warning-msg").html("Statement must start with SELECT. We can't have you \
            messing up our data...")
        $("#warning-div").slideDown()
        return

      # No errors so far: hide warning div and show progress bar
      $("#warning-div").slideUp()
      $("#run-progress-bar-container").slideDown(() ->
        $("#run-progress-bar").css('width', '50%')
        $http.post(phpSource, { "key" : "ll0ydr0tation", "query" : $scope.data.sqlQuery})
            .success(successCallback).error(errorCallback)
      )

    successCallback = (data, status) ->
      deferred = $q.defer()
      deferred.resolve(data)
      deferred.promise.then((data) ->
        $("#run-progress-bar").css('width', '100%')
        $("#run-progress-bar-container").delay(300).slideUp(() ->
          $("#run-progress-bar").css('width', '10%')
          $scope.$apply(() -> $scope.data.runDisabled = false)
          $scope.$apply(() -> $scope.data.tableCols = if data[0]? then _.keys(data[0]) else [])
          $scope.$apply(() -> $scope.data.tableContent = data)
          $("#results-table").show()
        )
      )

    errorCallback = (data, status) ->
      deferred = $q.defer()
      deferred.resolve(data)
      deferred.promise.then((data) ->
        $("#run-progress-bar-container").delay(300).slideUp(() ->
          $("#warning-msg").html(data + ' Status Code:' + status)
          $("#warning-div").slideDown()
          $("#run-progress-bar").css('width', '10%')
          $scope.$apply(() -> $scope.data.runDisabled = false)
        )
      )

    # Updates the url with the current selected freshmen and display mode
    updatePath = () =>
      sqlQueryParam = encodeURIComponent($scope.data.sqlQuery)
      $location.search('sqlQuery', sqlQueryParam)

    ###
    Initialization
    ###
    $scope.data = {}

    $scope.data.sqlQuery = if $routeParams.sqlQuery? then decodeURIComponent($routeParams.sqlQuery) else ""
    $scope.data.runDisabled = false;
    $scope.data.showImages = false;
    $scope.data.tableCols = [] # Hack to preserve order of JSON keys, so columns returned from PHP are preserved
