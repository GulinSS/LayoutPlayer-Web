'use strict'

### Directives ###

# register the module with Angular
angular.module('app.membership.directives', [])

.directive('imgAreaSelect', [
  ->
    controller: () ->
      @

    link: (scope, element, attrs) ->

])

.directive('screenLink', [
  ->
    scope:
      link: '=screenLink'
    link: (scope, element, attrs) ->
      element.click (event) ->
        event.preventDefault()
        $this = $(this)
        if event.ctrlKey
          element.fadeOut 'fast', ->
            window.location = $this.attr('href')
        else
          $('#screenSelector').css
            visibility: "visible"
          $('#threads').hide()
          position = $this.position()
          ias.setSelection position.left
          , position.top
          , position.left+$this.width()
          , position.top+$this.height()
          , true

          ias.setOptions({ show: true })
          ias.update()
          $(this).remove()

      scope.$on 'destroy', ->
        # element.removeEvent 'click'
])

.directive('layout', [
  ->
    (scope, element, attrs) ->
      img = element.find('img').first()
      ias = img.imgAreaSelect
        instance: true,
        # TODO: заменить на onCancelSelection
        onSelectEnd: (img, selection) ->
          if (selection.width < 5 || selection.height < 5) then return
          $a = $ "<a href='#' class='mark'></a>"
          $a.css
            top:selection.y1 - 3,
            left:selection.x1 - 3,
            width:selection.width,
            height:selection.height

          $("#links").append($a)
          # ias.cancelSelection() Пример того, как убирать выделение.

      $("a.mark").live "click", (event) ->
        event.preventDefault()
        $this = $(this)
        if event.ctrlKey
          element.fadeOut 'fast', ->
            window.location = $this.attr('href')
        else
          $('#screenSelector').css
            visibility: "visible"
          $('#threads').hide()
          position = $this.position()
          ias.setSelection position.left
          , position.top
          , position.left+$this.width()
          , position.top+$this.height()
          , true

          ias.setOptions({ show: true })
          ias.update()
          $(this).remove()

      scope.$on '$destroy', ->
        ias.setOptions
          remove: true
        $('.imgareaselect-selection').parent().remove()
        $('.imgareaselect-outer').remove()
        $("a.mark").die 'click'
])

.directive('screen', [
  "Screen"
  "ScreenEdited"
  "ScreenBlank"
  (Screen, ScreenEdited, ScreenBlank) ->
    templateUrl: "/membership/directive.screen.html"
    scope:
      screen: "=screen"
    link: (scope) ->
      scope.isEditable = () ->
        if scope.screen instanceof ScreenEdited
          return "edit"
        if scope.screen instanceof ScreenBlank
          return "create"
        "view"
])

.directive('project', [
  "Project"
  "ProjectEdited"
  "ProjectBlank"
  (Project, ProjectEdited, ProjectBlank) ->
    templateUrl: "/membership/directive.project.html"
    scope:
      project: "=project"
    link: (scope) ->
      scope.isEditable = () ->
        if scope.project instanceof ProjectEdited
          return "edit"
        if scope.project instanceof ProjectBlank
          return "create"
        "view"
])

.directive('screenLinkSelector', [
  ->
    (scope, element, attrs) ->
      element.select2()
])

.directive('imagesDndOnList', [
  ->
    (scope, element, attrs) ->
      prevented = (f) -> (e) ->
        e.stopPropagation()
        e.preventDefault()
        f(e)

      element.addClass 'droppable'

      element.bind
        dragenter: prevented ->
          element.addClass 'ondragenter'
          # Notifier.notify 'Бросьте файлы для создания нового проекта', \
          #  "Помощник в трудностях"
        dragover: prevented ->
          if !element.hasClass 'ondragenter'
            element.addClass 'ondragenter'
        dragleave: prevented -> element.removeClass 'ondragenter'
        drop: prevented (e) -> element.removeClass 'ondragenter'
])
