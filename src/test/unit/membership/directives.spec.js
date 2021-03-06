// Generated by CoffeeScript 1.4.0
'use strict';

describe("Тесты директив.", function() {
  var buildScope, finish, oneTest, test;
  finish = function() {
    this.scope.$destroy();
    return this.element.remove();
  };
  buildScope = function(dict) {
    return function($rootScope) {
      var scope;
      scope = $rootScope.$new();
      angular.extend(scope, dict);
      return scope;
    };
  };
  test = function(html, scope, asserts) {
    return inject(function($compile, $rootScope) {
      var context, directiveCompiled, scopeCompiled;
      scopeCompiled = scope($rootScope);
      directiveCompiled = $compile(html)(scopeCompiled);
      scopeCompiled.$apply();
      context = {
        scope: scopeCompiled,
        element: directiveCompiled
      };
      asserts.call(context);
      return finish.call(context);
    });
  };
  oneTest = function(directiveName, parameterName) {
    return function(value, asserts) {
      var html, scope, scopeParameter;
      html = "<div " + directiveName + "='" + parameterName + "'></div>";
      scopeParameter = {};
      scopeParameter[parameterName] = value;
      scope = buildScope(scopeParameter);
      return test(html, scope, asserts);
    };
  };
  beforeEach(module("app.membership.directives"));
  return beforeEach(module("membership.templates"));
});
