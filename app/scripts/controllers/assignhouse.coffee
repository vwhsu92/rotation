'use strict'

angular.module('rotationApp')
  .controller 'AssignhouseCtrl', ($scope, $routeParams, $location, $http, $q, freshmenFactory) ->

    phpSource = 'http://lloyd.caltech.edu/rotation/query.php'

    ###
    Functions
    ###

    # Returns the freshmen object for the given inum
    $scope.findFreshmen = (inum) ->
      _.findWhere($scope.data.freshmen, {"inum": inum})

    # Handler called when the show images checkbox is checked
    $scope.changeShowImages = () ->
      updatePath()

    # Handler called when the house is changed
    $scope.changeHouse = (inum) ->
      executeSqlUpdateStatement(inum, $scope.findFreshmen(inum)['picked'])

    # Handler to nicely close warning dialog
    $scope.clickCloseAlert = () ->
      $scope.data.alert = null

    # Updates frosh table with house and checks success from PHP
    executeSqlUpdateStatement = (inum, house) ->
      statement = "UPDATE test SET picked=\'" + house + "\' WHERE inum=" + inum + ";"

      $http.post(phpSource, { "key" : "ll0ydr0tation", "query" : statement})
          .success(() ->
            $scope.data.alert =
              type: 'success'
              msg: 'Successfully updated database: ' + inum + ' assigned to ' + house
          ).error((data) ->
            alert("ERROR! Database not updated: " + data)
            $scope.data.alert =
              type: 'danger'
              msg: data
          )

    # Handler called when freshmen selection changes. A workaround since ng-change doesnt
    # play nicely with select2. This watch method is triggered on page load, so we include
    # the equality check to make sure that we only update the path when the freshmen selection
    # actually changes.
    $scope.$watch('data.select2', (newVal, oldVal) ->
      if not _.isEqual(newVal, oldVal)
        updatePath()
    )

    # Updates the url with the current selected freshmen and display mode
    updatePath = () =>
      inumsParam =
        if $scope.data.select2?.length > 0
          $scope.data.select2.join(":")
        else
          ''
      showImagesParam = $scope.data.showImages
      $location.search('inums', inumsParam)
      $location.search('showImages', "" + showImagesParam)

    ###
    Initialization
    ###
    $scope.data = {}
    freshmenPromise = freshmenFactory.getFreshmen()
    freshmenPromise.then((freshmen) ->
      $scope.data.freshmen = freshmen)
    $scope.data.tableIdCols = ['inum', 'name']
    $scope.data.houses = 
      av: "avery"
      bl: "blacker"
      da: "dabney"
      fl: "fleming"
      ll: "lloyd"
      pa: "page"
      ri: "ricketts"
      ru: "ruddock"

    # Load any parameters from the route
    $scope.data.showImages = if $routeParams.showImages == "true" then true else false

    # Show any freshmen passed in as params
    $scope.data.select2 = $routeParams.inums?.split(":")


