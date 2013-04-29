angular.module('app.membership.services.viewModels.screenList', [])

.factory('Screen', [
  '$q'
  'arrayExts'
  'ScreenEdited'
  ($q, arrayExts, ScreenEdited) ->
    class Screen
      getId: -> @_id
      getProjectId: -> @_projectId

      constructor: (screenList, dto) ->
        @_screenList = screenList
        @_id = dto.id
        @_projectId = dto.projectId

        @src = dto.src
        @name = dto.name
        @first = dto.first

      delete: ->
        deferred = $q.defer()
        deferred.resolve()

        deferred.promise.then =>
          arrayExts.remove @_screenList, this

      # TODO: отправка на сервер данных!
      # TODO: пометка эскиза как первого, снятие с другого этой пометки
      update: (changeset) ->
        def =
          id: @_id
          projectId: @_projectId
          name: @name
          file: null
          first: false
        angular.extend def, changeset

        deferred = $q.defer()
        deferred.resolve(@src)

        deferred.promise.then (src) =>
          @name = def.name
          @first = def.first
          @src = src

      toEdit: ->
        arrayExts.replace @_screenList, this, new ScreenEdited this
])

.factory("ScreenEdited", [
  '$q'
  'arrayExts'
  ($q, arrayExts) ->
    class ScreenEdited
      constructor: (screen) ->
        @_screen = screen
        @name = @_screen.name
        @src = @_screen.src
        @first = @_screen.first
        @file = null

      cancel: ->
        @_replace()

      save: ->
        deferred = @_screen.update
          name: @name
          file: @file
          first: @first
        deferred.then => @_replace()

      _replace: ->
        # TODO: нарушение инкапсуляци, передать ответственность
        # TODO: screenList
        arrayExts.replace @_screen._screenList, this, @_screen
])

.factory("ScreenBlank", [
    '$q'
    'arrayExts'
    'Screen'
    ($q, arrayExts, Screen) ->
      class ScreenBlank
        constructor: (list, projectId) ->
          @_list = list
          @projectId = projectId
          @name = ""
          @src = "/add.png"
          @file = null
          @first = false
          # angular.extend this, new ProjectEditedMixin()

        promote: ->
          # TODO: подумать о том, чтобы сдесь была toggle-кнопка
          @first = true

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
            angular.extend dto,
              name: @name
              first: @first
              projectId: @projectId

            arrayExts.replace @_list, this,
            new Screen(@_list, dto)
])

