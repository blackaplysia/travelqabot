# Description
#  watson
#
# Commands:
#  watson - returns answer of question

url = require 'url'
https = require 'https'
shortid= require 'shortid'
redis_client = require './redis_client'
bmconf = require './bmconf'

module.exports = (robot) ->

  robot.respond /.*/, (msg) ->
    question = msg.message.text.replace /^travelqabot\s*/, ''

    query = url.parse "#{bmconf.qa.url}/v1/question/travel"
    options =
      host: query.hostname
      port: query.port
      path: query.pathname
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'Accept': 'application/json'
        'X-synctimeout': '30'
        'Authorization': bmconf.qa.auth

    watson_req = https.request options, (result) ->
      result.setEncoding 'utf-8'
      response_string = ''

      result.on 'data', (chunk) ->
        response_string += chunk

      result.on 'end', () ->
        id = shortid.generate()
        redis_client.set id, response_string

        uri_h = process.env.TRAVELQABOT_URI_SERVER ? "http://localhost:3000"
        uri_d = process.env.TRAVELQABOT_URI_DIR ? "/d"
        link = "#{uri_h}#{uri_d}/#{id}"
        response_length = process.env.TRAVELQABOT_RESPONSE_LENGTH ? "90"

        watson_answer = JSON.parse(response_string)[0]
        if watson_answer?
          q = watson_answer.question;
          if q
            if q.evidencelist?.length? > 0
              msg.send "#{q.evidencelist[0].text.substring(0, response_length)} #{link}"
            else if q.errorNotifications? > 0
              msg.send "Error: #{q.errornotifications[0].text}"
            else
              msg.send 'Error: No evidences or errors specified by Watson'
          else
            msg.send 'Error: No contents generated by Watson'

    watson_req.on 'error', (err) ->
      msg.send "Ooops, #{err}"

    questionData =
      'question':
        'evidenceRequest':
          'items': 1
        'questionText': question

    watson_req.write JSON.stringify(questionData)
    watson_req.end()
