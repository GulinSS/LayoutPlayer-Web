angular.module('app.login.directives', [])
.directive('fadeIn', [
  '$window'
  ($window) -> (scope, element, attrs) ->
    element.hide().appendTo($window.document.body)
    element.fadeIn "slow"

    scope.$on('$destroy', -> element.fadeOut "fast", -> element.remove())
])