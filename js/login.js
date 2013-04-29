'use strict';angular.module('app', ['ngCookies', 'ngResource', 'app.global.filters', 'app.global.services', 'app.login.directives', 'app.login.controllers', 'app.login.services', 'app.login.services.rest', 'login.templates']).config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider, config) {
    return $locationProvider.html5Mode(false);
  }
]).run([
  '$rootScope', 'session', 'template', 'shadow', function($rootScope, session, template, shadow) {
    var $authScope, s;

    s = shadow();
    $authScope = $rootScope.$new(true);
    $authScope.next = function() {
      $authScope.$destroy();
      return session.MoveBack();
    };
    return template('/login/modal.auth.html', $authScope);
  }
]);
'use strict';
/* Controllers
*/
angular.module('app.login.controllers', []).controller('authentication', [
  '$scope', 'isEmptyCheck', 'loginRest', function($scope, isEmptyCheck, loginRest) {
    $scope.isNotPermitForLogon = function() {
      return isEmptyCheck($scope.login) || isEmptyCheck($scope.password);
    };
    $scope.authenticate = function() {
      var data;

      data = {
        LoginName: $scope.login,
        PasswordGost: $scope.password
      };
      return loginRest.login(data, function() {
        return $scope.next();
      });
    };
    return $scope.test = function() {
      return $scope.next();
    };
  }
]);
angular.module('app.login.directives', []).directive('fadeIn', [
  '$window', function($window) {
    return function(scope, element, attrs) {
      element.hide().appendTo($window.document.body);
      element.fadeIn("slow");
      return scope.$on('$destroy', function() {
        return element.fadeOut("fast", function() {
          return element.remove();
        });
      });
    };
  }
]);
angular.module('app.login.services', []).factory('template', [
  '$http', '$templateCache', '$compile', '$q', function($http, $templateCache, $compile, $q) {
    return function(address, $scope) {
      var deffered;

      deffered = $q.defer();
      $http.get(address, {
        cache: $templateCache
      }).success(function(response) {
        var $response;

        $response = $(response);
        $compile($response)($scope);
        return deffered.resolve($response);
      }).error(function(reason) {
        return deffered.reject(reason);
      });
      return deffered.promise;
    };
  }
]).factory('shadow', [
  '$window', function($window) {
    return function() {
      var $body, $shadowDiv;

      $body = $($window.document.body);
      $body.addClass('obscured');
      $shadowDiv = $('<div></div>');
      $shadowDiv.addClass('shadow').appendTo($body);
      return function() {
        $shadowDiv.remove();
        return $body.removeClass('obscured');
      };
    };
  }
]);
'use strict';angular.module('app.login.services.rest', []).factory('loginRest', [
  '$resource', 'notifier', function($resource, notifier) {
    var resource;

    resource = $resource('/service/login', {}, {
      login: {
        method: "POST"
      }
    });
    return {
      login: function(data, callback) {
        var note;

        note = notifier.Begin("Проверка пары логин-пароль");
        return resource.login(data, function() {
          note.Complete();
          return callback();
        }, function() {
          return note.Error("Неверная пара");
        });
      }
    };
  }
]);
