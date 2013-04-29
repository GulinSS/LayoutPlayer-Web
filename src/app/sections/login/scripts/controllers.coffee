'use strict'

### Controllers ###

angular.module('app.login.controllers', [])

  .controller('authentication', [
    '$scope'
    'isEmptyCheck'
    'loginRest'
    ($scope, isEmptyCheck, loginRest) ->
      $scope.isNotPermitForLogon = () ->
        isEmptyCheck($scope.login) or isEmptyCheck($scope.password)

      $scope.authenticate = ->
        data =
          LoginName: $scope.login
          PasswordGost: $scope.password
        loginRest.login data, -> $scope.next()

      $scope.test = ->
        $scope.next()
  ])
