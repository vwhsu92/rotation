'use strict'

describe 'Controller: ViewfreshmenCtrl', () ->

  # load the controller's module
  beforeEach module 'rotationApp'

  ViewfreshmenCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ViewfreshmenCtrl = $controller 'ViewfreshmenCtrl', {
      $scope: scope
    }

