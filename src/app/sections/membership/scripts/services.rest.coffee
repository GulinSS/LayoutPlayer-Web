'use strict'

angular.module('app.membership.services.rest', [])

.service('projectsRest', [
  '$q'
  '$http'
  'notifier'
  ($q, $http, notifier) ->
    @getProjects = ->
      note = notifier.Begin("Получение списка проектов")
      deferred = $q.defer()
      $http.get('/services/projects')
      .success((response) ->
          note.Complete()
          deferred.resolve response
        )
      .error(-> note.Error("Неудалось получить список проектов"))

      deferred.promise

    @getScreensOfProject = (projectId) ->
      note = notifier.Begin("Получение списка экранов")
      deferred = $q.defer()
      $http.get("/services/projects/#{projectId}")
        .success((response) ->
          note.Complete()
          deferred.resolve response
        )
        .error(-> note.Error("Неудалось получить список экранов"))

      deferred.promise

    this
])
