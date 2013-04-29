'use strict'

### Controllers ###
angular.module('app.membership.controllers', [])

  .controller('projectList', [
    'Project'
    'ProjectBlank'
    '$scope'
    'projectsRest'
    (Project, ProjectBlank, $scope, projectsRest) ->
      $scope.projects = []
      $scope.addProject = () ->
        $scope.projects.unshift new ProjectBlank($scope.projects)

      projectsRest.getProjects().then (dtos) ->
        #$.each dtos, (v) ->
        #  $scope.projects.push new Project($scope.projects, v)
  ])

  .controller('screenList', [
    '$scope'
    '$routeParams'
    'projectsRest'
    'Screen'
    'ScreenBlank'
    ($scope, $routeParams, projectsRest, Screen, ScreenBlank) ->
      projectId = parseInt($routeParams.projectId)
      $scope.screens = []
      $scope.addScreen = () ->
        $scope.screens.unshift new ScreenBlank($scope.screens, projectId)

      projectsRest
        .getScreensOfProject(projectId)
        .then (dtos) ->
          #$.each dtos, (v) ->
          #  $scope.screens.push new Screen($scope.screens, v)
  ])

  .controller('screen', [
    '$scope'
    '$routeParams'
    ($scope, $routeParams) ->
      $scope.projectId = parseInt($routeParams.projectId)
      $scope.screenId = parseInt($routeParams.screenId)
      $scope.img = "/demo.jpg"
      $scope.links = [
        {
          point:
            x: 300
            y: 100
          width: 70
          height: 20
          targetId: 1
        }
        {
          point:
            x: 400
            y: 200
          width: 70
          height: 70
          targetId: 1
        }
      ]
  ])
