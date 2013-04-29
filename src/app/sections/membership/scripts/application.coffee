'use strict'

# Declare app level module which depends on filters, and services
angular.module('app', [
  'ngCookies'
  'ngResource'
  'app.global.filters'
  'app.global.services'
  'app.membership.directives'
  'app.membership.controllers'
  'app.membership.services.rest'
  'app.membership.services.viewModels.projectList'
  'app.membership.services.viewModels.screenList'
  'app.membership.services.viewModels.screen'
  'membership.templates'
])
.config([
  '$routeProvider'
  '$locationProvider'

  ($routeProvider, $locationProvider, config) ->

    $routeProvider
      .when('', {
        templateUrl: '/membership/projectList.html'
        controller: 'projectList'
      })
      .when('/:projectId', {
        templateUrl: '/membership/screenList.html'
        controller: 'screenList'
      })
      .when('/:projectId/:screenId', {
        templateUrl: '/membership/screen.html'
        controller: 'screen'
      })
      # Catch all
      .otherwise({redirectTo: ''})

    # Without serve side support html5 must be disabled.
    $locationProvider.html5Mode(false)
])