redis = require 'redis'
bmconf = require './bmconf'

client = redis.createClient bmconf.redis.port, bmconf.redis.host
if bmconf.redis.pass?
  client.auth bmconf.redis.pass

client.on "error", (err) ->
  console.log "Redis: #{err}"

process.on "beforeExit", () ->
  client.quit()

exports.c = client

exports.set = (key, val) ->
  client.set key, val

exports.get = (key, callback) ->
  client.get key, callback

exports.keys = (pattern, callback) ->
  client.keys pattern, callback
