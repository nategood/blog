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

# todo break out into conf file system
conf =
  analytics:
    account: "UA-20300690-1"
    domain: "nategood.com"
  port: 7890

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
    conf: conf
    intro: read basedir + "/content/partials/intro.md"
    # articles: [cache.rand(), cache.rand()]

app.get "/dev/random", (req, res) ->
  # todo add Location header to actual article URL
  res.render "article.jade",
    conf: conf
    content: cache.rand()

app.get "/home/nate/posts", (req, res) ->
  res.render "posts.jade",
    conf: conf
    articles: cache.links()

app.get "/:article", (req, res, next) ->
  content = cache.get "#{req.params.article}.md"
  res.status(404).render("errors/404.jade", conf: conf) unless content
  res.render "article.jade",
    conf: conf
    content: content

server = app.listen conf.port