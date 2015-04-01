if process.env.VCAP_SERVICES?
  services = JSON.parse process.env.VCAP_SERVICES
  if services['MonitoringAndAnalytics']?
    require 'knj-plugin'
    require 'loganalysis'
    console.log 'Loaded libraries for MonitoringAndAnalytics service'
