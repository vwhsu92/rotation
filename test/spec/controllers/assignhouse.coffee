'use strict'

describe 'Controller: AssignhouseCtrl', () ->

  # load the controller's module
  beforeEach module 'rotationApp'

  AssignhouseCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AssignhouseCtrl = $controller 'AssignhouseCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
