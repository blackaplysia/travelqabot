if process.env.VCAP_SERVICES?
  services = JSON.parse process.env.VCAP_SERVICES

service_name = 'redis-2.6'
service_instance_name = services?[service_name]?[0]?.name ? 'redis'
service_instance_plan = services?[service_name]?[0]?.plan ? 'local'
service_host = services?[service_name]?[0]?.credentials?.host ? 'localhost'
service_port = services?[service_name]?[0]?.credentials?.port ? '6379'
service_password = services?[service_name]?[0]?.credentials?.password ? null

console.log "Redis: #{service_instance_name}(#{service_instance_plan}): #{service_host}:#{service_port}"

exports.host = service_host
exports.port = service_port
exports.password = service_password
