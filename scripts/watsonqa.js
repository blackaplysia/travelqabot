// Description
//  watson
//
// Commands:
//  watson - returns answer of question

var url = require('url');
var https = require('https');
var bmconf = require('./bmconf');

(function() {
  module.exports = function(robot) {
    return robot.respond(/\s(\S+)/i, function(msg) {

      var question = msg.match[1];

      var query = url.parse(bmconf.url + '/v1/question/travel');
      var options = {
        host: query.hostname,
        port: query.port,
        path: query.pathname,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-synctimeout': '30',
          'Authorization': bmconf.auth
        }
      };

      var watson_req = https.request(options, function(result) {
      result.setEncoding('utf-8');
      var response_string = '';
      result.on('data', function(chunk) {
        response_string += chunk;
      });
      result.on('end', function() {
        var answers = JSON.parse(response_string)[0];
        if (answers && answers.question &&
          answers.question.evidencelist &&
          answers.question.evidencelist.length > 0) {
            answer = answers.question.evidencelist[1].text;
          } else {
            answer = "Sorry, Watson has no answers for you.";
          }
        }
       return msg.send(answer.substring(0, 120));
      });
      watson_req.on('error', function(err) {
        res.status(500);
        return msg.send("Ooops, #{err}");
      });

      var questionData = {
        'question': {
          'evidenceRequest': {
            'items': 1
          },
          'questionText': question
        }
      };

      watson_req.write(JSON.stringify(questionData));
      watson_req.end();
    });
  };
}).call(this);
