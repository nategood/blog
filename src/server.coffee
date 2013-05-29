http = require("http")
express = require("express")
md = require("markdown").markdown
fs = require("fs")
_ = require("underscore")

# todo breakout
read = (path) ->
  md.toHTML((fs.readFileSync path).toString())
init = (dir)->
  names = fs.readdirSync dir
  content = names.map (fn) -> read "#{dir}/#{fn}"
  cache = _.object names, content

  get: (fn) -> cache[fn]
  rand: () -> cache[names[Math.floor(Math.random() * names.length)]]
  links: () -> names.map (name) -> {link: "/" + name.replace(".md", "")}

basedir = __dirname.replace /\/src$/, ""
cache = init basedir + "/content/articles"

# App Configuration and Middleware
app = express()
app.set "views", __dirname + "/templates"
app.use express.logger 'dev'
app.use "/assets", express.static(basedir + "/assets")

# Routes
app.get "/", (req, res) ->
  res.render "home.jade",
    intro: read basedir + "/content/partials/intro.md"
    articles: [cache.rand(), cache.rand()]

app.get "/dev/random", (req, res) ->
  res.render "article.jade",
    content: cache.rand()

app.get "/home/nate/posts", (req, res) ->
  res.render "posts.jade",
    articles: cache.links()

app.get "/:article", (req, res, next) ->
  content = cache.get "#{req.params.article}.md"
  res.status(404).render("errors/404.jade") unless content
  res.render "article.jade",
    content: content

server = app.listen 8989