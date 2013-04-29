'use strict'

describe "Тесты директив.", ->
  finish = ->
    @scope.$destroy()
    @element.remove()

  buildScope = (dict) ->
    ($rootScope) ->
      scope = $rootScope.$new()
      angular.extend scope, dict
      return scope

  test = (html, scope, asserts) ->
    inject ($compile, $rootScope) ->
      scopeCompiled = scope $rootScope
      directiveCompiled = $compile(html)(scopeCompiled)
      scopeCompiled.$apply()
      context =
        scope: scopeCompiled
        element: directiveCompiled

      asserts.call context
      finish.call context

  oneTest = (directiveName, parameterName) ->
    (value, asserts) ->
      html = "<div #{directiveName}='#{parameterName}'></div>"
      scopeParameter = {}
      scopeParameter[parameterName] = value
      scope = buildScope scopeParameter
      test html, scope, asserts

  beforeEach module "app.membership.directives"
  beforeEach module "membership.templates"
