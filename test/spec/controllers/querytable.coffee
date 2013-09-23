'use strict'

describe 'Controller: QuerytableCtrl', () ->

  # load the controller's module
  beforeEach module 'rotationApp'

  QuerytableCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    QuerytableCtrl = $controller 'QuerytableCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
