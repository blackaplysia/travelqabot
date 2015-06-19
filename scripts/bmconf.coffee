cfenv =require('cfenv')
appEnv = cfenv.getAppEnv

monitor_service_name = 'MonitoringAndAnalytics'
monitor = appEnv.getService monitor_service_name
if monitor?
  require 'knj-plugin'
  require 'loganalysis'
  console.log "Loaded libraries for #{monitor_service_name}"

redis_service_name = 'redis-2.6'
redis = appEnv.geService redis_service_name
redis_name = redis?.name ? '(redis)'
redis_plan = redis?.plan ? '(local)'
redis_host = redis?.credentials?.host ? '(localhost)'
redis_port = redis?.credentials?.port ? '6379'
redis_pass = redis?.credentials?.password ? '(pass)'

if redis?
  console.log "#{redis_service_name}: #{redis_name}(#{redis_plan}): #{redis_host}:#{redis_port}"

bmconf.redis =
  host: redis_host,
  port: redis_port,
  pass: redis_pass

qa_service_name = 'question_and_answer'
qa = appEnv.geService qa_service_name
qa_name = qa?.name ? '(watsonqa)'
qa_plan = qa?.plan ? '(none)'
qa_url = qa?.credentials?.url ? '(url)'
qa_user = qa?.credentials?.username ? '(user)'
qa_pass = qa?.credentials?.password ? '(pass)'

console.log "#{qa_service_name}: #{qa_name}(#{qa_plan}): #{qa_user}:XXXX@#{qa_url}"

bmconf.qa =
  url: qa_url,
  auth:  "Basic #{new Buffer(qa_user + ':' + qa_pass).toString('base64')}"
