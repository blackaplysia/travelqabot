redis = require 'redis'
redisconf = require './redisconf'

client = redis.createClient redisconf.port, redisconf.host
if redisconf.password?
  client.auth redisconf.password

client.on "error", (err) ->
  console.log "Redis: #{err}"

process.on "beforeExit", () ->
  client.quit

exports.c = client

exports.set = (key, val) ->
  client.set key, val

exports.get = (key, callback) ->
  client.get key, callback
