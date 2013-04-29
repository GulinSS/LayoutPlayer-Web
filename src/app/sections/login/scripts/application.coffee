'use strict'

# Declare app level module which depends on filters, and services
angular.module('app', [
  'ngCookies'
  'ngResource'
  'app.global.filters'
  'app.global.services'
  'app.login.directives'
  'app.login.controllers'
  'app.login.services'
  'app.login.services.rest'
  'login.templates'
])
.config([
  '$routeProvider'
  '$locationProvider'

  ($routeProvider, $locationProvider, config) ->

    #$routeProvider
#      .when('/auth', {templateUrl: '/global/templates/modal.auth.html'})

    # Catch all
 #     .otherwise({redirectTo: '/auth'})

    # Without serve side support html5 must be disabled.
    $locationProvider.html5Mode(false)
])
.run([
  '$rootScope'
  'session'
  'template'
  'shadow'
  ($rootScope, session, template, shadow) ->
    s = shadow()

    $authScope = $rootScope.$new(true)
    $authScope.next = ->
      $authScope.$destroy()

      session.MoveBack()

    template '/login/modal.auth.html', $authScope
])