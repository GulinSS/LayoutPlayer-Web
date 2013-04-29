casper = require('casper').create
  pageSettings:
    loadImages: false
    loadPlugins: false

casper.start "http://localhost:3333/sections/membership/#/1", ->
  @capture 'sections.membership.screenList.png'
  @test.comment 'ScreenList'

casper.then ->
  @test.assertExists 'ul.thumbnails',
  'the list must be present by thumbnails'
  @test.assertSelectorHasText '.btn.btn-primary', 'Добавить эскиз',
  'add layout button must be present'
  @test.assertExists '.thumbnail .btn.btn-danger i.icon-remove',
  'every layout can be deleted by user'

casper.then ->
  try
    @click '.btn.btn-primary i.icon-plus'
  catch e
    @test.fail 'failed to click on Add Layout button, may be it is not exists?'

addLayoutSubmitData =
  layout: 'sample.png'
  description: 'Some description'
casper.waitForSelector '#addLayout'
, ->
  @capture 'sections.membership.addLayout.png'
  @test.comment 'AddLayout'

  @test.assertExists '.btn.btn-primary i.icon-ok',
  'save button must be present'
  @test.assertExists '.btn i.icon-ban-circle',
  'cancel button must be preset'
  @test.assertExists 'form#addLayout-form textarea[name=description]',
  'description field must be present'
  @test.assertExists 'form#addLayout-form input[type=file, name=layout]',
  'Layout upload field must be present'

  @fill 'form#addLayout-form', addLayoutSubmitData, true

  @test.done()
, ->
  @test.fail 'failed to load Add Layout page, may be it is not exists?'
, 1000

casper.then ->
  @test.assertTextExists addLayoutSubmitData.description,
  'Added layout must be present after form submit'
  @test.assertSelectorHasText 'div.thumbnail p', addLayoutSubmitData.description,
  'Added layout must have correct description'

casper.thenEvaluate (data) ->
  $correctProject = $('div.thumbnail p').filter ->
    @text() is data.description
  $correctProject.first().parent().find(".btn.btn-danger").click()
, addLayoutSubmitData

casper.then ->
  @test.assertSelectorDoesntHaveText 'div.thumbnail p', addLayoutSubmitData.description,
  'Added test layout must be removed after click on delete button'
  @test.done()

casper.run()