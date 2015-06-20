cfenv =require('cfenv')
appEnv = cfenv.getAppEnv()

monitor_service_name = 'travelqabot-monitor'
monitor = appEnv.getService monitor_service_name
if monitor?
  require 'knj-plugin'
  require 'loganalysis'
  console.log "Loaded libraries for #{monitor_service_name}"

redis_service_name = 'travelqabot-redis'
redis = appEnv.getService redis_service_name
redis_name = redis?.name ? '(redis)'
redis_plan = redis?.plan ? '(local)'
redis_host = redis?.credentials?.host ? '127.0.0.1'
redis_port = redis?.credentials?.port ? '6379'
redis_pass = redis?.credentials?.password ? null

console.log "#{redis_service_name}: #{redis_name}(#{redis_plan}): #{redis_host}:#{redis_port}"

qa_service_name = 'travelqabot-service'
qa = appEnv.getService qa_service_name
qa_name = qa?.name ? '(watsonqa)'
qa_plan = qa?.plan ? '(none)'
qa_url = qa?.credentials?.url ? '(url)'
qa_user = qa?.credentials?.username ? '(user)'
qa_pass = qa?.credentials?.password ? '(pass)'

console.log "#{qa_service_name}: #{qa_name}(#{qa_plan}): #{qa_user}:XXXX@#{qa_url}"

module.exports =

  redis:
    host: redis_host
    port: redis_port
    pass: redis_pass

  qa:
    url: qa_url
    auth:  "Basic #{new Buffer(qa_user + ':' + qa_pass).toString('base64')}"
