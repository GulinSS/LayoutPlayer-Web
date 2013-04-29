angular.module('app.login.services', [])
# Загрузка шаблона и инициализация его директив-контроллеров
.factory('template', [
  '$http'
  '$templateCache'
  '$compile'
  '$q'
  ($http, $templateCache, $compile, $q) -> (address, $scope) ->
    deffered = $q.defer()
    $http.get(address, {cache: $templateCache}).success((response) ->
      $response = $(response)

      $compile($response)($scope)

      deffered.resolve($response)
    ).error((reason) -> deffered.reject(reason))

    deffered.promise
])

# Отбрасывает тень на весь экран, может быть полезно для модальных окон,
# повторный вызов функции на результивном объекте уберет тень.
.factory('shadow', [
  '$window'
  ($window) -> ->
    $body = $ $window.document.body
    $body.addClass('obscured')
    $shadowDiv = $ '<div></div>'
    $shadowDiv.addClass('shadow').appendTo($body)
    ->
      $shadowDiv.remove()
      $body.removeClass('obscured')
])