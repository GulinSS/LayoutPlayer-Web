angular.module('app.global.services', [])

.service('arrayExts', [
  ->
    @remove = (arr, item) ->
      i = $.inArray(item, arr)
      arr.splice i, 1

    @replace = (arr, itemToReplace, item) ->
      i = $.inArray(itemToReplace, arr)
      arr[i] = item
])


# Сервис управления текущем путем браузера, может выполнять редирект и получать
# текущий путь.
.service('browserPath', [
  '$window'
  ($window) ->
    redirect: (value) -> $window.location = value
    current: -> $window.location.pathname
])

# Проверка на наличие значения
.constant('isEmptyCheck', (value) ->
  value is undefined or value is null or value is "" or value.length is 0
)

# Преобразование дат .NET ("/Date(1315512000000+0400)/") в формат дат JS
# без использования Eval: http://stackoverflow.com/a/2316066
.constant('jsonDateConverter', (value) ->
  new Date(parseInt(value.substr(6)))
)

# Проверка наличия сесси у пользователя, в случае ее отстутсвия, выполняется
# перенаправление на станицу логина.
.factory('session', [
  '$cookieStore'
  'browserPath'
  ($cookieStore, browserPath) ->
    Clear: -> $cookieStore.remove "ss-id"
    Check: -> if $cookieStore.get("ss-id") is undefined
      $cookieStore.put "redirectTo", browserPath.current()
      browserPath.redirect "/sections/login"
    MoveBack: -> browserPath.redirect($cookieStore.get "redirectTo")
])

# Показ спиннера в правом нижнем углу экрана приложения, отражающего загрузку
# данных
.factory('notifier', ->
  Begin: (text) ->
    notifier = Notifier.notify \
      text, "Передача данных", "/img/ajax-loader-small.gif", -1

    Complete: -> notifier.setOk().hide()
    Error: (text) -> notifier.setError(text)
)
