if process.env.VCAP_SERVICES?
  services = JSON.parse process.env.VCAP_SERVICES

service_name = 'question_and_answer'
service_instance_name = services?[service_name]?[0]?.name ? 'watsonqa'
service_instance_plan = services?[service_name]?[0]?.plan ? 'none'
service_url = services?[service_name]?[0]?.credentials?.url ? '????'
service_username = services?[service_name]?[0]?.credentials?.username ? '????'
service_password = services?[service_name]?[0]?.credentials?.password ? '????'

console.log "WatsonQA: #{service_instance_name}(#{service_instance_plan}): #{service_username}:XXXX@#{service_url}"

exports.url = service_url
exports.username = service_username
exports.password = service_password
exports.auth =  "Basic #{new Buffer(service_username + ':' + service_password).toString('base64')}"
