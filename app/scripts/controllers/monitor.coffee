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
        return (house.froshCnt - house.runningTotal)
      untruncated = $scope.data.roundInfo[round] * house.froshCnt + house.trunc
      actuallyPicked = parseInt(untruncated)

      if (round == 0)
        actuallyPicked = house.GAed

      house.trunc = untruncated - actuallyPicked
      house.runningTotal += actuallyPicked
      return actuallyPicked

    $scope.updatePath = () =>
      outputStr = ""
      for round in $scope.data.rounds
        if round.visible
          outputStr += 'T'
        else
          outputStr += 'F'
      $location.search('rounds', "" + outputStr)

    $scope.processHouse = (house) ->
      output = house
      output.froshRemaining = 0
      output.knownDeals = 0
      output.froshInRound = [0,0,0,0,0,0]
      output.runningTotal = 0
      output.trunc = 0
      output.picked = 0
      output.females = 0
      output.round = ({'num': num, 'available':0, 'mustPick':$scope.mustPick(num, output)} for num in [0..5])
      for frosh in $scope.data.freshmen
        if frosh.picked is null
          if frosh[output.abrv] == 22
            output.knownDeals++
          if frosh[output.abrv] <= 20
            output.froshRemaining++
          for round in output.round
            if frosh['round' + round.num]? and frosh['round' + round.num].indexof(output.abrv) != -1
              round.available++
        else
          output.picked++
          if frosh.female
            output.females++

      pickedCount = output.picked
      for round in output.round
        if pickedCount > round.mustPick
          round.picked = round.mustPick
          pickedCount -= round.mustPick
        else
          round.picked = pickedCount
          pickedCount = 0
        if output.name == 'Lloyd'
          round.picksPerLloyd = 1
        else
          round.picksPerLloyd = round.mustPick / $scope.lloyd.round[round.num].mustPick

      output.dealsLeft = output.deals - output.knownDeals

      output.froshRemainingLower = output.froshRemaining - output.dealsLeft

      return output

    $scope.updateLloydPicksLeft = (house) ->
      house.lloydPicksLeftLower = 0
      house.lloydPicksLeftUpper = 0

      # Assume the upper bound we are the only house picking up that houses froshes

      runningCount = 0
      for round in house.round
        if round.picked > 0
          for i in [1..round.picked]
            runningCount += 1
            if (runningCount + house.lloydPicksLeftUpper < house.froshRemainingLower)
              house.lloydPicksLeftUpper += 1 / round.picksPerLloyd


      runningCount = 6  #Assume other 6 non-involved houses are picking before us
      for round in house.round
        if round.picked > 0
          for i in [1..round.picked]
            runningCount += 1
            if (runningCount + house.lloydPicksLeftLower < house.froshRemainingLower)
              newLloydPicksLeftLower += 1 / round.picksPerLloyd
              if (parseInt(newLloydPicksLeftLower) > parseInt(house.lloydPicksLeftLower))
                for otherHouse in $scope.data.houses
                  runningCount += otherHouse.round[round.num].picksPerLloyd



    ###
    Initialization
    ###

    $scope.data = {}
    freshmenPromise = freshmenFactory.getFreshmen()
    freshmenPromise.then((freshmen) ->
      $scope.data.freshmen = freshmen
      $scope.data.houses = []
      for house in $scope.data.houseAbrvs
        if house.name == 'Lloyd'
          $scope.lloyd = $scope.processHouse(house)

      for house in $scope.data.houseAbrvs
        $scope.data.houses.push($scope.processHouse(house))

      for house in $scope.data.houses
        $scope.updateLloydPicksLeft(house)
      )


    $scope.data.houseAbrvs = [{'abrv':'av', 'froshCnt':20, 'deals':10, 'GAed':4, 'name':'Avery'},
                              {'abrv':'bl', 'froshCnt':21, 'deals':10, 'GAed':4, 'name':'Blacker'},
                              {'abrv':'da', 'froshCnt':22, 'deals':10, 'GAed':4, 'name':'Dabney'},
                              {'abrv':'fl', 'froshCnt':23, 'deals':10, 'GAed':4, 'name':'Fleming'},
                              {'abrv':'ll', 'froshCnt':24, 'deals':10, 'GAed':4, 'name':'Lloyd'},
                              {'abrv':'pa', 'froshCnt':25, 'deals':10, 'GAed':4, 'name':'Page'},
                              {'abrv':'ri', 'froshCnt':26, 'deals':10, 'GAed':4, 'name':'Ricketts'},
                              {'abrv':'ru', 'froshCnt':27, 'deals':10, 'GAed':4, 'name':'Ruddock'}]
    $scope.data.roundInfo = [0.25, 0.25, 0.15, 0.15, 0.15, 1]
    $scope.data.rounds = ({'num': num, 'visible': false} for num in [0..5])
    $scope.data.roundColumns = [['Round', 'num'], ['Available', 'available'], ['Picked', 'picked'], ['To Pick', 'mustPick'], ['Picks Per Lloyd', 'picksPerLloyd']]

    if $routeParams.rounds?
      console.log($routeParams.rounds)
      for round in $scope.data.rounds
        if $routeParams.rounds[round.num] == 'T'
          round.visible = true




