// Generated by CoffeeScript 1.4.0
'use strict';

describe("services", function() {
  beforeEach(module("app.global.services"));
  return describe("session", function() {
    beforeEach(module("ngCookies"));
    it("Cookie с идентификатором сессии должен быть уничтожен", inject(function(session, $cookieStore) {
      $cookieStore.put("ss-id", "10");
      session.Clear();
      return expect($cookieStore.get("ss-id")).toBe(void 0);
    }));
    it("Если нет Cookie с индетификатором сессии, то редирект на логин", function() {
      var spyDoRedirect;
      spyDoRedirect = jasmine.createSpy("Метод редиректа");
      module(function($provide) {
        return $provide.constant('browserPath', {
          current: function() {
            return "/";
          },
          redirect: spyDoRedirect
        });
      });
      return inject(function(session) {
        session.Check();
        return expect(spyDoRedirect).toHaveBeenCalled();
      });
    });
    it("Если есть Cookie с индетификатором сессии, то нет редиректа на логин", function() {
      var spyDoRedirect;
      spyDoRedirect = jasmine.createSpy("Метод редиректа");
      module(function($provide) {
        return $provide.constant('doRedirect', spyDoRedirect);
      });
      return inject(function(session, $cookieStore) {
        $cookieStore.put("ss-id", "10");
        session.Check();
        return expect(spyDoRedirect.calls.length).toBe(0);
      });
    });
    return xit("Если пользователь был на внутренней странице, вылетел, а потом зашел        обратно, то его нужно вернуть на прежнюю страницу", function() {
      return error();
    });
  });
});
