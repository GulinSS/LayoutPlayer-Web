'use strict';angular.module('app', ['ngCookies', 'ngResource', 'app.global.filters', 'app.global.services', 'app.membership.directives', 'app.membership.controllers', 'app.membership.services.rest', 'app.membership.services.viewModels.projectList', 'app.membership.services.viewModels.screenList', 'app.membership.services.viewModels.screen', 'membership.templates']).config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider, config) {
    $routeProvider.when('', {
      templateUrl: '/membership/projectList.html',
      controller: 'projectList'
    }).when('/:projectId', {
      templateUrl: '/membership/screenList.html',
      controller: 'screenList'
    }).when('/:projectId/:screenId', {
      templateUrl: '/membership/screen.html',
      controller: 'screen'
    }).otherwise({
      redirectTo: ''
    });
    return $locationProvider.html5Mode(false);
  }
]);
'use strict';
/* Controllers
*/
angular.module('app.membership.controllers', []).controller('projectList', [
  'Project', 'ProjectBlank', '$scope', 'projectsRest', function(Project, ProjectBlank, $scope, projectsRest) {
    $scope.projects = [];
    $scope.addProject = function() {
      return $scope.projects.unshift(new ProjectBlank($scope.projects));
    };
    return projectsRest.getProjects().then(function(dtos) {});
  }
]).controller('screenList', [
  '$scope', '$routeParams', 'projectsRest', 'Screen', 'ScreenBlank', function($scope, $routeParams, projectsRest, Screen, ScreenBlank) {
    var projectId;

    projectId = parseInt($routeParams.projectId);
    $scope.screens = [];
    $scope.addScreen = function() {
      return $scope.screens.unshift(new ScreenBlank($scope.screens, projectId));
    };
    return projectsRest.getScreensOfProject(projectId).then(function(dtos) {});
  }
]).controller('screen', [
  '$scope', '$routeParams', function($scope, $routeParams) {
    $scope.projectId = parseInt($routeParams.projectId);
    $scope.screenId = parseInt($routeParams.screenId);
    $scope.img = "/demo.jpg";
    return $scope.links = [
      {
        point: {
          x: 300,
          y: 100
        },
        width: 70,
        height: 20,
        targetId: 1
      }, {
        point: {
          x: 400,
          y: 200
        },
        width: 70,
        height: 70,
        targetId: 1
      }
    ];
  }
]);
'use strict';
/* Directives
*/
angular.module('app.membership.directives', []).directive('imgAreaSelect', [
  function() {
    return {
      controller: function() {
        return this;
      },
      link: function(scope, element, attrs) {}
    };
  }
]).directive('screenLink', [
  function() {
    return {
      scope: {
        link: '=screenLink'
      },
      link: function(scope, element, attrs) {
        element.click(function(event) {
          var $this, position;

          event.preventDefault();
          $this = $(this);
          if (event.ctrlKey) {
            return element.fadeOut('fast', function() {
              return window.location = $this.attr('href');
            });
          } else {
            $('#screenSelector').css({
              visibility: "visible"
            });
            $('#threads').hide();
            position = $this.position();
            ias.setSelection(position.left, position.top, position.left + $this.width(), position.top + $this.height(), true);
            ias.setOptions({
              show: true
            });
            ias.update();
            return $(this).remove();
          }
        });
        return scope.$on('destroy', function() {});
      }
    };
  }
]).directive('layout', [
  function() {
    return function(scope, element, attrs) {
      var ias, img;

      img = element.find('img').first();
      ias = img.imgAreaSelect({
        instance: true,
        onSelectEnd: function(img, selection) {
          var $a;

          if (selection.width < 5 || selection.height < 5) {
            return;
          }
          $a = $("<a href='#' class='mark'></a>");
          $a.css({
            top: selection.y1 - 3,
            left: selection.x1 - 3,
            width: selection.width,
            height: selection.height
          });
          return $("#links").append($a);
        }
      });
      $("a.mark").live("click", function(event) {
        var $this, position;

        event.preventDefault();
        $this = $(this);
        if (event.ctrlKey) {
          return element.fadeOut('fast', function() {
            return window.location = $this.attr('href');
          });
        } else {
          $('#screenSelector').css({
            visibility: "visible"
          });
          $('#threads').hide();
          position = $this.position();
          ias.setSelection(position.left, position.top, position.left + $this.width(), position.top + $this.height(), true);
          ias.setOptions({
            show: true
          });
          ias.update();
          return $(this).remove();
        }
      });
      return scope.$on('$destroy', function() {
        ias.setOptions({
          remove: true
        });
        $('.imgareaselect-selection').parent().remove();
        $('.imgareaselect-outer').remove();
        return $("a.mark").die('click');
      });
    };
  }
]).directive('screen', [
  "Screen", "ScreenEdited", "ScreenBlank", function(Screen, ScreenEdited, ScreenBlank) {
    return {
      templateUrl: "/membership/directive.screen.html",
      scope: {
        screen: "=screen"
      },
      link: function(scope) {
        return scope.isEditable = function() {
          if (scope.screen instanceof ScreenEdited) {
            return "edit";
          }
          if (scope.screen instanceof ScreenBlank) {
            return "create";
          }
          return "view";
        };
      }
    };
  }
]).directive('project', [
  "Project", "ProjectEdited", "ProjectBlank", function(Project, ProjectEdited, ProjectBlank) {
    return {
      templateUrl: "/membership/directive.project.html",
      scope: {
        project: "=project"
      },
      link: function(scope) {
        return scope.isEditable = function() {
          if (scope.project instanceof ProjectEdited) {
            return "edit";
          }
          if (scope.project instanceof ProjectBlank) {
            return "create";
          }
          return "view";
        };
      }
    };
  }
]).directive('screenLinkSelector', [
  function() {
    return function(scope, element, attrs) {
      return element.select2();
    };
  }
]).directive('imagesDndOnList', [
  function() {
    return function(scope, element, attrs) {
      var prevented;

      prevented = function(f) {
        return function(e) {
          e.stopPropagation();
          e.preventDefault();
          return f(e);
        };
      };
      element.addClass('droppable');
      return element.bind({
        dragenter: prevented(function() {
          return element.addClass('ondragenter');
        }),
        dragover: prevented(function() {
          if (!element.hasClass('ondragenter')) {
            return element.addClass('ondragenter');
          }
        }),
        dragleave: prevented(function() {
          return element.removeClass('ondragenter');
        }),
        drop: prevented(function(e) {
          return element.removeClass('ondragenter');
        })
      });
    };
  }
]);
'use strict';angular.module('app.membership.services.rest', []).service('projectsRest', [
  '$q', '$http', 'notifier', function($q, $http, notifier) {
    this.getProjects = function() {
      var deferred, note;

      note = notifier.Begin("Получение списка проектов");
      deferred = $q.defer();
      $http.get('/services/projects').success(function(response) {
        note.Complete();
        return deferred.resolve(response);
      }).error(function() {
        return note.Error("Неудалось получить список проектов");
      });
      return deferred.promise;
    };
    this.getScreensOfProject = function(projectId) {
      var deferred, note;

      note = notifier.Begin("Получение списка экранов");
      deferred = $q.defer();
      $http.get("/services/projects/" + projectId).success(function(response) {
        note.Complete();
        return deferred.resolve(response);
      }).error(function() {
        return note.Error("Неудалось получить список экранов");
      });
      return deferred.promise;
    };
    return this;
  }
]);
'use strict';angular.module('app.membership.services.viewModels.projectList', []).factory('Project', [
  '$q', 'arrayExts', 'ProjectEdited', function($q, arrayExts, ProjectEdited) {
    var Project;

    return Project = (function() {
      Project.prototype.getId = function() {
        return this._id;
      };

      function Project(list, dto) {
        this._projectList = list;
        this._id = dto.id;
        this.name = dto.name;
        this.src = dto.src;
      }

      Project.prototype["delete"] = function() {
        var deferred,
          _this = this;

        deferred = $q.defer();
        deferred.resolve();
        return deferred.promise.then(function() {
          return arrayExts.remove(_this._projectList, _this);
        });
      };

      Project.prototype.update = function(changeset) {
        var def, deferred,
          _this = this;

        def = {
          id: this._id,
          name: this.name,
          files: []
        };
        angular.extend(def, changeset);
        deferred = $q.defer();
        deferred.resolve(this.src);
        return deferred.promise.then(function(src) {
          _this.name = def.name;
          return _this.src = src;
        });
      };

      Project.prototype.toEdit = function() {
        return arrayExts.replace(this._projectList, this, new ProjectEdited(this));
      };

      return Project;

    })();
  }
]).factory('ProjectEditedMixin', [
  function() {
    var ProjectEditedMixin;

    return ProjectEditedMixin = (function() {
      function ProjectEditedMixin() {}

      ProjectEditedMixin.prototype.addFiles = function(files) {
        var _this = this;

        return angular.forEach(files, v(function() {
          return _this.files.push(v);
        }));
      };

      return ProjectEditedMixin;

    })();
  }
]).factory('ProjectEdited', [
  'arrayExts', 'ProjectEditedMixin', function(arrayExts, ProjectEditedMixin) {
    var ProjectEdited;

    return ProjectEdited = (function() {
      function ProjectEdited(project) {
        this._project = project;
        this.name = this._project.name;
        this.src = this._project.src;
        this.files = [];
        angular.extend(this, new ProjectEditedMixin());
      }

      ProjectEdited.prototype.cancel = function() {
        return this._replace();
      };

      ProjectEdited.prototype.save = function() {
        var _this = this;

        return this._project.update({
          name: this.name,
          files: this.files
        }).then(function() {
          return _this._replace();
        });
      };

      ProjectEdited.prototype._replace = function() {
        return arrayExts.replace(this._project._projectList, this, this._project);
      };

      return ProjectEdited;

    })();
  }
]).factory('ProjectBlank', [
  '$q', 'arrayExts', 'Project', 'ProjectEditedMixin', function($q, arrayExts, Project, ProjectEditedMixin) {
    var ProjectBlank;

    return ProjectBlank = (function() {
      function ProjectBlank(list) {
        this._list = list;
        this.name = "";
        this.src = "/add.png";
        this.files = [];
        angular.extend(this, new ProjectEditedMixin());
      }

      ProjectBlank.prototype["delete"] = function() {
        return arrayExts.remove(this._list, this);
      };

      ProjectBlank.prototype.save = function() {
        var deferred,
          _this = this;

        deferred = $q.defer();
        deferred.resolve({
          id: 1,
          src: "/demo300x200.jpg"
        });
        return deferred.promise.then(function(dto) {
          angular.extend(dto, {
            name: _this.name
          });
          return arrayExts.replace(_this._list, _this, new Project(_this._list, dto));
        });
      };

      return ProjectBlank;

    })();
  }
]);
angular.module('app.membership.services.viewModels.screen', []).factory('LinkArea', [
  function() {
    var LinkArea;

    return LinkArea = (function() {
      function LinkArea(dto) {
        this.id = null;
        this.point = null;
        this.width = null;
        this.height = null;
        this.targetLayoutId = null;
        angular.extend(this, dto);
      }

      LinkArea.prototype.activate = function() {};

      LinkArea.prototype.update = function(changeset) {};

      return LinkArea;

    })();
  }
]);
angular.module('app.membership.services.viewModels.screenList', []).factory('Screen', [
  '$q', 'arrayExts', 'ScreenEdited', function($q, arrayExts, ScreenEdited) {
    var Screen;

    return Screen = (function() {
      Screen.prototype.getId = function() {
        return this._id;
      };

      Screen.prototype.getProjectId = function() {
        return this._projectId;
      };

      function Screen(screenList, dto) {
        this._screenList = screenList;
        this._id = dto.id;
        this._projectId = dto.projectId;
        this.src = dto.src;
        this.name = dto.name;
        this.first = dto.first;
      }

      Screen.prototype["delete"] = function() {
        var deferred,
          _this = this;

        deferred = $q.defer();
        deferred.resolve();
        return deferred.promise.then(function() {
          return arrayExts.remove(_this._screenList, _this);
        });
      };

      Screen.prototype.update = function(changeset) {
        var def, deferred,
          _this = this;

        def = {
          id: this._id,
          projectId: this._projectId,
          name: this.name,
          file: null,
          first: false
        };
        angular.extend(def, changeset);
        deferred = $q.defer();
        deferred.resolve(this.src);
        return deferred.promise.then(function(src) {
          _this.name = def.name;
          _this.first = def.first;
          return _this.src = src;
        });
      };

      Screen.prototype.toEdit = function() {
        return arrayExts.replace(this._screenList, this, new ScreenEdited(this));
      };

      return Screen;

    })();
  }
]).factory("ScreenEdited", [
  '$q', 'arrayExts', function($q, arrayExts) {
    var ScreenEdited;

    return ScreenEdited = (function() {
      function ScreenEdited(screen) {
        this._screen = screen;
        this.name = this._screen.name;
        this.src = this._screen.src;
        this.first = this._screen.first;
        this.file = null;
      }

      ScreenEdited.prototype.cancel = function() {
        return this._replace();
      };

      ScreenEdited.prototype.save = function() {
        var deferred,
          _this = this;

        deferred = this._screen.update({
          name: this.name,
          file: this.file,
          first: this.first
        });
        return deferred.then(function() {
          return _this._replace();
        });
      };

      ScreenEdited.prototype._replace = function() {
        return arrayExts.replace(this._screen._screenList, this, this._screen);
      };

      return ScreenEdited;

    })();
  }
]).factory("ScreenBlank", [
  '$q', 'arrayExts', 'Screen', function($q, arrayExts, Screen) {
    var ScreenBlank;

    return ScreenBlank = (function() {
      function ScreenBlank(list, projectId) {
        this._list = list;
        this.projectId = projectId;
        this.name = "";
        this.src = "/add.png";
        this.file = null;
        this.first = false;
      }

      ScreenBlank.prototype.promote = function() {
        return this.first = true;
      };

      ScreenBlank.prototype["delete"] = function() {
        return arrayExts.remove(this._list, this);
      };

      ScreenBlank.prototype.save = function() {
        var deferred,
          _this = this;

        deferred = $q.defer();
        deferred.resolve({
          id: 1,
          src: "/demo300x200.jpg"
        });
        return deferred.promise.then(function(dto) {
          angular.extend(dto, {
            name: _this.name,
            first: _this.first,
            projectId: _this.projectId
          });
          return arrayExts.replace(_this._list, _this, new Screen(_this._list, dto));
        });
      };

      return ScreenBlank;

    })();
  }
]);
