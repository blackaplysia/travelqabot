# Description
#  Detail of answers by Watson
#
# Commands:
#  d - detail of answers

redis_client = require './redis_client'

module.exports = (robot) ->

  uri_server = process.env.TRAVELQABOT_URI_SERVER ? "localhost"
  uri_dir = process.env.TRAVELQABOT_URI_DIR ? "/d"

  robot.router.get "/", (req, res) ->
    res.type 'html'
    res.send "\
<html>\
  <body>\
    <h1>No contents here</h1>\
  </body>\
</html>"
    res.end

  robot.router.get "/robots.txt", (req, res) ->
    res.type 'text'
    res.send "User-Agent: *\nDisallow: /\n"
    res.end

  robot.router.get "#{uri_dir}/:id", (req, res) ->
    id = req.params.id

    redis_client.get id, (err, data_stored) ->
      if err? or not data_stored?
        res.type 'html'
        res.send "\
<html>\
  <body>\
    <h1>#{id}: Internal Error</h1>\
  </body>\
</html>"
        res.end
        console.log "Cannot retrieve query log (#{id}): #{err}"
      else
        data = JSON.parse(data_stored)
        raw = JSON.stringify data, null, "  "
        q = data[0].question;

        qclass_string = ''
        qclass_sep =''
        q.qclasslist.forEach (qclass) ->
          qclass_string = qclass_string + qclass_sep + qclass.value.toLowerCase()
          qclass_sep = ', '

        focus_string = ''
        if not q.focuslist?
          focus_string = '(null)'
        else
          focus_sep =''
          q.focuslist.forEach (focus) ->
            focus_string = focus_string + focus_sep + focus.value
            focus_sep = ', '

        lat_string = ''
        if not q.latlist?
          lat_string = '(null)'
        else
          lat_sep =''
          q.latlist.forEach (lat) ->
            lat_string = lat_string + lat_sep + lat.value
            lat_sep = ', '

        q_text = q.questionText
        ev = q.evidencelist[0]
        ev_text = ev.text
        ev_confidence = ev.value
        ev_title = ev.title
        ev_file = ev.metadataMap.originalfile
        res.type 'html'
        res.send "\
<html>\
  <body>\
    <h1>Watson Query Log</h1>
    <h2>Summary</h2>\
    <table border=\"1\">\
      <tr><td>Q&amp;A ID</td><td>#{id}</td></tr>\
      <tr><td>Question</td><td>#{q_text}</td></tr>\
      <tr><td>Evidence</td><td>#{ev_text}</td></tr>\
      <tr><td>Confidence</td><td>#{ev_confidence}</td></tr>\
      <tr><td>Title</td><td>#{ev_title}</td></tr>\
      <tr><td>Filename</td><td>#{ev_file}</td></tr>\
      <tr><td>Question Class List</td><td>#{qclass_string}</td></tr>\
      <tr><td>Focus List</td><td>#{focus_string}</td></tr>\
      <tr><td>LAT List</td><td>#{lat_string}</td></tr>\
    </table>\
    <h2>Raw data</h2>\
    <pre>#{raw}</pre>\
  </body>\
</html>"
        res.end

