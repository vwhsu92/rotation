'use strict'

angular.module('rotationApp')
  .controller 'MonitorCtrl', ($scope, $routeParams, $location, freshmenFactory, imageLocationFactory) ->

    ###
    Functions
    ###

    $scope.anyRoundVisible = () ->
      for round in $scope.data.rounds
        if round.visible
          return true
      return false

    # Returns the freshmen object for the given id
    $scope.findFreshmen = (id) ->
      _.findWhere($scope.data.freshmen, {"id": id})

    $scope.mustPick = (round, house) ->
      if (round == 5)
        return (house.totalFrosh - house.runningTotal)
      untruncated = $scope.data.roundInfo[round] * house.totalFrosh + house.trunc
      house.trunc = untruncated - parseInt(untruncated)
      house.runningTotal += parseInt(untruncated)
      return parseInt(untruncated)

    $scope.processHouse = (house) ->
      output = house
      output.froshRemaining = 0
      output.knownDeals = 0
      output.froshInRound = [0,0,0,0,0,0]
      output.runningTotal = 0;
      output.trunc = 0;
      output.round = ({'num': num, 'available':0, 'mustPick':$scope.mustPick(num, output)} for num in [0..5])
      for frosh in $scope.data.freshmen
        if frosh.picked is not null
          if frosh[output.abrv] == 22
            output.knownDeals++
          if frosh[output.abrv] <= 20
            output.froshRemaining++
          # if frosh[]

      output.dealsLeft = output.deals - output.knownDeals

      return output


    ###
    Initialization
    ###

    $scope.data = {}
    freshmenPromise = freshmenFactory.getFreshmen()
    freshmenPromise.then((freshmen) ->
      $scope.data.freshmen = freshmen
      $scope.data.houses = []
      for house in $scope.data.houseAbrvs
        $scope.data.houses.push($scope.processHouse(house))
      )
    $scope.data.houseAbrvs = [{'abrv':'av', 'froshCnt':20, 'deals':10, 'name':'Avery'},
                              {'abrv':'bl', 'froshCnt':20, 'deals':10, 'name':'Blacker'},
                              {'abrv':'da', 'froshCnt':20, 'deals':10, 'name':'Dabney'},
                              {'abrv':'fl', 'froshCnt':20, 'deals':10, 'name':'Fleming'},
                              {'abrv':'ll', 'froshCnt':20, 'deals':10, 'name':'Lloyd'},
                              {'abrv':'pa', 'froshCnt':20, 'deals':10, 'name':'Page'},
                              {'abrv':'ri', 'froshCnt':20, 'deals':10, 'name':'Ricketts'},
                              {'abrv':'ru', 'froshCnt':20, 'deals':10, 'name':'Ruddock'}]
    $scope.data.roundInfo = [0.25, 0.25, 0.15, 0.15, 0.15, 1]
    $scope.data.rounds = ({'num': num, 'available':0, 'mustPick':0, 'visible': false} for num in [0..5])