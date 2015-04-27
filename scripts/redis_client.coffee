redis = require 'redis'
redis_conf = require './redis_conf'

client = redis.createClient redis_conf.port, redis_conf.host
if redis_conf.password?
  client.auth redis_conf.password

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
