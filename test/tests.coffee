assert = chai.assert
request = httpplease
plugins = httppleaseplugins

testServerUrl = 'http://localhost:4001'

describe 'httpplease', ->
  it 'performs a get request', (done) ->
    request.get "#{ testServerUrl }/getjson", (err, res) ->
      assert.equal res.text, JSON.stringify(hello: 'world')
      done()

  it 'sends headers', (done) ->
    req =
      url: "#{ testServerUrl }/headers"
      headers:
        hello: 'world'
    request.get req, (err, res) ->
      json = JSON.parse res.text
      assert.equal json.hello, 'world'
      done()

  describe 'use', ->
    it 'adds a plugin', ->
      startCount = request.plugins.length
      assert.equal request.use({}).plugins.length, startCount + 1

    it "doesn't mutate the request function", ->
      startCount = request.plugins.length
      request.use {}
      assert.equal request.plugins.length, startCount

  describe 'bare', ->
    it 'creates a request function without plugins', ->
      assert.equal request.use({}).bare().plugins.length, 0

describe 'plugins', ->
  describe 'jsonparser', ->
    it 'parses json responses', (done) ->
      request
        .use plugins.jsonparser
        .get "#{ testServerUrl }/getjson", (err, res) ->
          assert.deepEqual res.body, hello: 'world'
          done()
