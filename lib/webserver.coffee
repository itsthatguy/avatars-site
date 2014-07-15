
http     = require('http')
express  = require('express')
path     = require('path')
favicon  = require('serve-favicon')
findPort = require('find-port')
colors   = require('colors')

app           = express()
webserver     = http.createServer(app)
basePath      = path.join(__dirname, '..')
generatedPath = path.join(basePath, '.generated')
vendorPath    = path.join(basePath, 'bower_components')
faviconPath   = path.join(basePath, 'app', 'favicon.ico')

app.engine('.html', require('hbs').__express)

app.use(favicon(faviconPath))
app.use('/assets', express.static(generatedPath))
app.use('/vendor', express.static(vendorPath))
console.log vendorPath

port = process.env.PORT || 3002
if port == 3002
  findPort port, port + 100, (ports) ->
    webserver.listen(ports[0])
else
  webserver.listen(port)

webserver.on 'listening', ->
  address = webserver.address()
  console.log "[Firepit] Server running at http://#{address.address}:#{address.port}".green

app.get '/', (req, res) -> res.render(generatedPath + '/index.html')

# app.get /^\/(\w+)(?:\.)?(\w+)?/, (req, res) ->
#   path = req.params[0]
#   ext  = req.params[1] ? "html"
#   res.render(path.join(generatedPath, "#{path}.#{ext}"))


module.exports = app
