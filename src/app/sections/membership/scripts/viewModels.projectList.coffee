'use strict'

# ## View models for membership namespace
angular.module('app.membership.services.viewModels.projectList', [])

# ### Project
# Root object for user interaction
.factory('Project', [
  '$q'
  'arrayExts'
  'ProjectEdited'
  ($q, arrayExts, ProjectEdited) ->
    class Project
      getId: -> @_id

      # Accepts two arguments:
      # >*   *projectList* - reference to list of projects
      # >*   *dto* - Poco for merging with project instance
      constructor: (list, dto) ->
        @_projectList = list
        @_id = dto.id
        @name = dto.name
        @src = dto.src

      # Delete current project. It removes project from
      # project list also.
      # > *TODO: communicate with the server*
      delete: ->
        deferred = $q.defer()
        deferred.resolve()

        deferred.promise.then =>
          arrayExts.remove @_projectList, this

      # Update current project. It attempts to
      # retrieve new name and file list from
      # parameter. After it will communicate
      # with server to retrieve source url for
      # project image.
      # > *TODO: communicate with the server,
      # > send them def and retrieve new source url*
      update: (changeset) ->
        def =
          id: @_id
          name: @name
          files: []
        angular.extend def, changeset

        deferred = $q.defer()
        deferred.resolve(@src)

        deferred.promise.then (src) =>
          @name = def.name
          @src = src

      # Change state to edition
      toEdit: ->
        arrayExts.replace @_projectList, this, new ProjectEdited this
])

# ### ProjectEditedMixin
# Mixin for project edition and creation.
# It contains general methods for both objects
.factory('ProjectEditedMixin', [
  ->
    class ProjectEditedMixin
      addFiles: (files) ->
        angular.forEach files, v =>
          @files.push v
])

# ### ProjectEdited
# Edition state for project
.factory('ProjectEdited', [
  'arrayExts'
  'ProjectEditedMixin'
  (arrayExts, ProjectEditedMixin) ->
    class ProjectEdited
      # First parameter is a project which
      # will be accepted for changes
      constructor: (project) ->
        @_project = project
        @name = @_project.name
        @src = @_project.src
        @files = []
        angular.extend this, new ProjectEditedMixin()

      cancel: ->
        @_replace()

      # Save changes to project and return them
      save: ->
        # TODO: проверка на наличие имени проекта
        @_project.update(name: @name, files: @files).then =>
          @_replace()

      _replace: ->
        # TODO: нарушение инкапсуляци, передать ответственность
        # TODO: projectList
        arrayExts.replace @_project._projectList, this, @_project
])

# ### ProjectBlank
.factory('ProjectBlank', [
  '$q'
  'arrayExts'
  'Project'
  'ProjectEditedMixin'
  ($q, arrayExts, Project, ProjectEditedMixin) ->
    class ProjectBlank
      constructor: (list) ->
        @_list = list
        @name = ""
        @src = "/add.png"
        @files = []
        angular.extend this, new ProjectEditedMixin()

      delete: ->
        arrayExts.remove @_list, this

      save: ->
        # TODO: соединение с сервером, сохранение проекта
        # TODO: проверка на наличие картинки и подписи
        deferred = $q.defer()
        deferred.resolve
          id: 1
          src: "/demo300x200.jpg"

        deferred.promise.then (dto) =>
          angular.extend dto, name: @name
          arrayExts.replace @_list, this,
            new Project(@_list, dto)
])


