// Description
//  watson
//
// Commands:
//  watson - returns answer of question

var url = require('url');
var https = require('https');

(function() {
  module.exports = function(robot) {
    var bmconf = require('./bmconf');

    return robot.respond(/.*/, function(msg) {
      var question = msg.message.text;

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
          var watson_answer = JSON.parse(response_string)[0];
          var qa = watson_answer.question;
          if (watson_answer && qa &&
            qa.evidencelist &&
            qa.evidencelist.length > 0) {
            answer = qa.evidencelist[1].text;
          } else {
            answer = qa.errorNotifications[0].text +
              qa.questionText;
          }
          msg.send(answer.substring(0, 120));
        });
      });

      watson_req.on('error', function(err) {
        msg.send("Ooops, " + err);
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
