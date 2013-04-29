utils = require('utils')
casper = require('casper').create
  pageSettings:
    loadImages: false
    loadPlugins: false

casper.start "http://localhost:3333/sections/membership/", ->
  @capture 'sections.membership.projectList.png'
  @test.comment 'ProjectList'

  @test.assertExists 'ul.thumbnails',
  'the list must be present by thumbnails'
  @test.assertSelectorHasText '.btn.btn-primary', 'Добавить проект',
  'add project button must be present'
  @test.assertExists '.thumbnail .btn.btn-danger i.icon-remove',
  'every project can be deleted by user'

casper.then ->
  try
    @click '.btn.btn-primary i.icon-plus'
  catch e
    @test.fail 'failed to click on Add Project button, may be it is not exists?'

addProjectSubmitData =
  logo: 'sample.png'
  header: 'Some project'
casper.waitForSelector '#addProject'
, ->
  @capture 'sections.membership.addProject.png'
  @test.comment 'AddProject'

  @test.assertExists '.btn.btn-primary i.icon-ok',
  'save button must be present'
  @test.assertExists '.btn i.icon-ban-circle',
  'cancel button must be preset'
  @test.assertExists 'form#addProject-form input[type=text, name=header]',
  'header form field must be present'
  @test.assertExists 'form#addProject-form input[type=file, name=logo]',
  'Logo upload field must be present'

  @fill 'form#addProject-form', addProjectSubmitData, true

  @test.done()
, ->
  @test.fail 'failed to load Add Project page, may be it is not exists?'
, 1000

casper.then ->
  @test.assertTextExists addProjectSubmitData.description,
  'Added project must be present after form submit'
  @test.assertSelectorHasText 'div.thumbnail h3', addProjectSubmitData.header,
  'Added project must have correct header'

casper.thenEvaluate (data) ->
  $correctProject = $('div.thumbnail h3').filter ->
    @text() is data.header
  $correctProject.first().parent().find(".btn.btn-danger").click()
, addProjectSubmitData

casper.then ->
  @test.assertSelectorDoesntHaveText 'div.thumbnail h3', addProjectSubmitData.header,
  'Added test project must be removed after click on delete button'
  @test.done()

#casper.then ->
#@debugHTML()
casper.run()