var redis = require('redis');
var redisconf = require('./redisconf');

var client = redis.createClient(redisconf.port, redisconf.host);
if (redisconf.password) {
  client.auth(redisconf.password);
}

client.on("error", function(err) {
  console.log("Redis: " + err);
});

process.on("beforeExit", function() {
  client.quit();
});

module.exports = {
  c: client,
  set: function(key, val) {
    client.set(key, val);
  },
  get: function(key, callback) {
    client.get(key, callback);
  }
}
