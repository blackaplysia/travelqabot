var appInfo = JSON.parse(process.env.VCAP_APPLICATION || '{}');

var service_host = '{????}';
var service_port = '{????}';
var service_password = '{????}';

if (process.env.VCAP_SERVICES) {
    var services = JSON.parse(process.env.VCAP_SERVICES);
    var service_name = 'redis-2.6';
    if (services[service_name]) {
	var service_instance_name = services[service_name][0].name;
	var service_instance_plan = services[service_name][0].plan;
	var svc = services[service_name][0].credentials;
	service_host = svc.host;
	service_port = svc.port;
	service_password = svc.password;
    } else {
	console.log('Service ' + service_name + ' is not in the VCAP_SERVICES.');
    }
} else {
    console.log('No VCAP_SERVICES found in ENV.');
}

console.log(service_instance_name + '(' + service_instance_plan + '): ' + service_host + ':' + service_port);

exports.host = service_host;
exports.port = service_port;
exports.password = service_password;
