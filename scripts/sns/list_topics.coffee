# Description:
#   List sns topics
#

moment = require 'moment'
tsv    = require 'tsv'

module.exports = (robot) ->
  robot.respond /sns list topics$/i, (msg) ->

    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    sns  = new aws.SNS()

    sns.listTopics {}, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        response.Topics.forEach (topic) ->
          msg.send(topic.TopicArn)
