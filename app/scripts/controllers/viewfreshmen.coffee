'use strict'

angular.module('rotationApp')
  .controller 'ViewfreshmenCtrl', ($scope, $routeParams, $location, freshmenFactory) ->

    ###
    Functions
    ###

    # Returns the freshmen object for the given inum
    $scope.findFreshmen = (inum) ->
      _.findWhere($scope.data.freshmen, {"inum": inum})

    # Handler called when the display mode changes
    $scope.changeDisplay = () ->
      setCols()
      updatePath()

    # Handler called when the show images checkbox is checked
    $scope.changeShowImages = () ->
      updatePath()

    # Handler called when freshmen selection changes. A workaround since ng-change doesnt
    # play nicely with select2. This watch method is triggered on page load, so we include
    # the equality check to make sure that we only update the path when the freshmen selection
    # actually changes.
    $scope.$watch('data.select2', (newVal, oldVal) ->
      if not _.isEqual(newVal, oldVal)
        updatePath()
    )

    # Updates the displayed table columns
    setCols = () ->
      switch ($scope.data.displayMode)
        when 'simple' then $scope.data.tableCols = ['inum', 'name']
        when 'full' then $scope.data.tableCols = ['inum', 'name', 'house', 'ranking']
        when 'lloyd' then $scope.data.tableCols = ['inum', 'name', 'ranking']
        else $scope.data.tableCols = ['inum', 'name']

    # Updates the url with the current selected freshmen and display mode
    updatePath = () =>
      inumsParam =
        if $scope.data.select2?.length > 0
          $scope.data.select2.join(":")
        else
          ''
      displayModeParam = $scope.data.displayMode
      showImagesParam = $scope.data.showImages
      $location.search('inums', inumsParam)
      $location.search('displayMode', displayModeParam)
      $location.search('showImages', "" + showImagesParam)

    ###
    Initialization
    ###
    $scope.data = {}
    freshmenPromise = freshmenFactory.getFreshmen()
    freshmenPromise.then((freshmen) ->
      $scope.data.freshmen = freshmen)
    $scope.data.displayModeValues = ['simple', 'full', 'lloyd']

    # Load any parameters from the route
    $scope.data.displayMode =
        if $routeParams.displayMode in $scope.data.displayModeValues
          $routeParams.displayMode
        else
          'simple'
    setCols($scope.data.displayMode)

    $scope.data.showImages = if $routeParams.showImages == "true" then true else false

    # Show any freshmen passed in as params
    $scope.data.select2 = $routeParams.inums?.split(":")

