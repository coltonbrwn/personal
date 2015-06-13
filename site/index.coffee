express = require('express')
exphbs  = require('express-handlebars')
cm = require '../cm.coffee'

app = express()

hbs = exphbs.create
  extname: 'hbs'
  defaultLayout: 'main'
  layoutsDir: './site/views/layouts'
  partialsDir: "./site/views/partials"
  helpers:
    selected: (ctx, opts) ->
      regex = new RegExp('^'+ctx+'(/.*)?$')
      if regex.test(this.path) then 'selected'
    fragment: (opts) ->
      frags = this.path.split('/')
      frags[frags.length-1]



app.engine '.hbs', hbs.engine

app.set('view engine', '.hbs');
app.set('views', "./site/views");

app.use (req, res, next) ->
  res.locals.path = req.originalUrl.replace(/^\//, '')
  do next

app.use express.static './public'

app.get '/', (req, res) ->
  res.render 'home', content: cm('home.md')

app.get '/projects', (req, res) ->
  res.render 'projects', projects:
    cm('projects', summarize:true).map (proj) ->
      {content: proj}

app.get '/projects/:id', (req, res) ->
  res.render 'project',
    content: cm("projects/#{req.params.id}.md")

app.get '/resume', (req, res) ->
  res.render 'resume', content: cm('resume.md')

app.get '/blog', (req, res) ->
  res.locals.test = 'hello'
  res.render 'index'

module.exports = app