casper = require('casper').create
  pageSettings:
    clientScripts: [
        'jquery.simulate.js'
      ]
    loadImages: true
    loadPlugins: false

casper.on 'remote.message', (msg) ->
  @echo('remote message caught: ' + msg)

casper.start "http://localhost:3333/sections/membership/#/1/1", ->
  @capture 'sections.membership.screenLink.png'
  @test.comment 'ScreenLink'

casper.then ->
  @test.assertExists '#layout',
  'there is the main element'
  @test.assertExists '#layout #img_layout #img_wrap img',
  'there is the image'
  @test.assertExists '#layout #img_layout #img_wrap #links',
  'there is the links area'

casper.then ->
  result = @evaluate ->
    beforeTest = $('#links a.mark').length
    simulateDrag = ($element, source, destination) ->
      $element.simulate 'mousedown', source
      $(document).simulate 'mousemove', destination
      $(document).simulate 'mousemove', destination
      $element.simulate 'mouseup', source

    selectRect = ($element, sideSize, padding) ->
      offset = $element.offset()
      source =
        clientX: offset.left - $(document).scrollLeft() + padding
        clientY: offset.top - $(document).scrollTop() + padding

      destination =
        clientX: source.clientX+sideSize,
        clientY: source.clientY+sideSize

      simulateDrag $element, source, destination

    testSelection = ($element) -> selectRect $element, 50, 1
    hideSelection = ($element) -> selectRect($element, 0, 80)

    ###
    $('img').one 'load', ->
      $img = $ 'img'
      testSelection $img
      hideSelection $img
    ###

    $img = $ 'img'
    testSelection $img
    # hideSelection $img
    beforeTest < $('#links a.mark').length
  @capture 'sections.membership.screenLink2.png'
  @test.assertTruthy result,
    'after simulation link count must be incremented'

casper.then ->
  @test.assertExists '#selectionOptions',
  'there is the selection options area must be present'
  @test.assertExists 'form select[name=slideId]',
  'there is the slide selection must be present'
  @test.assertExists '.btn.btn-primary i.icon-ok',
  'Ok button must be present'
  @test.assertExists '.btn.btn-danger i.icon-ban-circle',
  'Cancel button must be present'
  @test.assertVisible '.imgareaselect-outer',
  'Resizable area must be visible after drag'

  try
    @fill 'form',
      slideId: 0
    , false
  catch e
    @test.fail 'failed to fill form'

  try
    @click '.btn.btn-primary i.icon-ok'
  catch e
    @test.fail 'failed to send form'

casper.then ->
  try
    @click 'a.mark'
  catch e
    @test.fail 'failed to click on already added link'
  @test.assertExists '#selectionOptions',
  'there is the selection options area must be present for editing after click'
  try
    @click '.btn.btn-primary i.icon-ok'
  catch e
    @test.fail 'failed to save changes'

casper.then ->
  result = @evaluate ->
    lastPath = window.location.pathname
    e = jQuery.Event 'click'
    e.ctrlKey = true
    $('a.mark').trigger e
    return lastPath != window.location.pathname
  @test.assertTruthy result,
  'Ctrl + Click on the link must redirect to other slide'

casper.back()
casper.then ->
  try
    @click 'a.mark'
  catch e
    @test.fail 'failed to click on already added link'
  try
    @click '.btn.btn-danger i.icon-ban-circle'
  catch e
    @test.fail 'failed to delete link'
  @test.assertDoesntExist 'a.mark',
  'Any links must no exists after delete'

casper.then ->
  @test.done()

casper.run()
