'use strict'

# jasmine specs for services go here

describe "services", ->

  beforeEach module "app.global.services"

  describe "session", ->

    beforeEach module "ngCookies"

    it "Cookie с идентификатором сессии должен быть уничтожен",
      inject (session, $cookieStore) ->
        $cookieStore.put "ss-id", "10"
        session.Clear()
        expect($cookieStore.get("ss-id")).toBe undefined

    it "Если нет Cookie с индетификатором сессии, то редирект на логин", ->
      spyDoRedirect = jasmine.createSpy "Метод редиректа"
      module ($provide) ->
        $provide.constant 'browserPath',
          current: -> "/"
          redirect: spyDoRedirect
      inject (session) ->
        session.Check()
        expect(spyDoRedirect).toHaveBeenCalled()

    it "Если есть Cookie с индетификатором сессии, то нет редиректа на логин", ->
      spyDoRedirect = jasmine.createSpy "Метод редиректа"
      module ($provide) -> $provide.constant 'doRedirect', spyDoRedirect
      inject (session, $cookieStore) ->
        $cookieStore.put "ss-id", "10"
        session.Check()
        expect(spyDoRedirect.calls.length).toBe 0

    xit "Если пользователь был на внутренней странице, вылетел, а потом зашел
        обратно, то его нужно вернуть на прежнюю страницу", ->
      error()