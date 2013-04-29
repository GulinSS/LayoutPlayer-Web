'use strict'

angular.module('app.login.services.rest', [])

.factory('loginRest', [
  '$resource'
  'notifier'
  ($resource, notifier) ->
    resource = $resource '/service/login', {},
      login:
        method: "POST"

    login: (data, callback) ->
      note = notifier.Begin("Проверка пары логин-пароль")
      resource.login data
      , ->
        note.Complete()
        callback()
      , ->
        note.Error("Неверная пара")
])
