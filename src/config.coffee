exports.config =
  # See docs at http://brunch.readthedocs.org/en/latest/config.html.
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
  files:
    javascripts:
      joinTo:
        'js/vendor.js'      : /^vendor/
        'js/global.js'      : /^app(\/|\\)global/
        'js/index.js'       : /^app(\/|\\)sections(\/|\\)index(\/|\\)scripts/
        'js/login.js'       : /^app(\/|\\)sections(\/|\\)login(\/|\\)scripts/
        'js/membership.js': /^app(\/|\\)sections(\/|\\)membership(\/|\\)scripts/
      order:
        before: [
          'vendor/scripts/console-helper.js'
          'vendor/scripts/jquery-1.7.2.js'
          'vendor/scripts/jquery-ui-1.8.23.js'
          'vendor/scripts/jquery.imgareaselect.js'
          'vendor/scripts/select2.js'
          'vendor/scripts/angular/angular.js'
          'vendor/scripts/angular/angular-resource.js'
          'vendor/scripts/angular/angular-cookies.js'
          'vendor/scripts/angular/angular-bootstrap.js'
          'vendor/scripts/angular-ui.js'
          # Удалить следующие скрипты при наличии серверной части
          'test/vendor/angular/angular-mocks.js'
          'vendor/scripts/jquery.simulate.js'
        ]

    stylesheets:
      joinTo:
        'css/global.css': /^app(\/|\\)global(\/|\\)styles/
    templates:
      joinTo: 
        'js/dontUseMe' : /^app/ #это грязный хак, чтобы компилировать Jade.
        #'js/classJournal-templates.js' : /^app(\/|\\)sections(\/|\\)classJournal(\/|\\)templates/

   plugins:
      jade:
        pretty: yes # Adds pretty-indentation whitespaces to output (false by default)
      jade_angular:
        modules_folder: 'templates'
        locals: {}

  # Enable or disable minifying of result js / css files.
  # minify: true
