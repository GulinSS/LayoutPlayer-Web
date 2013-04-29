angular.element(document).ready(function() {
  return angular.bootstrap(document, ['app']);
});
'use strict';
/* Filters
*/
angular.module('app.global.filters', []).filter('flat', function() {
  return function(elements, subarray) {
    var flat;

    flat = [];
    angular.forEach(elements, function(v, k) {
      return flat = flat.concat(v[subarray]);
    });
    return flat;
  };
}).filter('isEmpty', [
  'isEmptyCheck', function(isEmptyCheck) {
    return function(value) {
      return isEmptyCheck(value);
    };
  }
]);
angular.module('app.global.services', []).service('arrayExts', [
  function() {
    this.remove = function(arr, item) {
      var i;

      i = $.inArray(item, arr);
      return arr.splice(i, 1);
    };
    return this.replace = function(arr, itemToReplace, item) {
      var i;

      i = $.inArray(itemToReplace, arr);
      return arr[i] = item;
    };
  }
]).service('browserPath', [
  '$window', function($window) {
    return {
      redirect: function(value) {
        return $window.location = value;
      },
      current: function() {
        return $window.location.pathname;
      }
    };
  }
]).constant('isEmptyCheck', function(value) {
  return value === void 0 || value === null || value === "" || value.length === 0;
}).constant('jsonDateConverter', function(value) {
  return new Date(parseInt(value.substr(6)));
}).factory('session', [
  '$cookieStore', 'browserPath', function($cookieStore, browserPath) {
    return {
      Clear: function() {
        return $cookieStore.remove("ss-id");
      },
      Check: function() {
        if ($cookieStore.get("ss-id") === void 0) {
          $cookieStore.put("redirectTo", browserPath.current());
          return browserPath.redirect("/sections/login");
        }
      },
      MoveBack: function() {
        return browserPath.redirect($cookieStore.get("redirectTo"));
      }
    };
  }
]).factory('notifier', function() {
  return {
    Begin: function(text) {
      var notifier;

      notifier = Notifier.notify(text, "Передача данных", "/img/ajax-loader-small.gif", -1);
      return {
        Complete: function() {
          return notifier.setOk().hide();
        },
        Error: function(text) {
          return notifier.setError(text);
        }
      };
    }
  };
});
