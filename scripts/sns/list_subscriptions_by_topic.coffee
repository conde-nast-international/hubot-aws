# Description:
#   List sns subscriptions by topic
#
# Commands:
#   hubot sns list subscriptions by topic --topic="arn:aws..."

module.exports = (robot) ->

  robot.respond /sns list subscriptions by topic(.*)$/i, (msg) ->

    topic_name_capture = /--topic-name=(.*?)( |$)/.exec(msg)
    topicArn = if msg.includes(/(--topic)/) then topic_name_capture else msg.send "Please include --topic"

    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact admin"
      return

    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    sns  = new aws.SNS()

    sns.listSubscriptionsByTopic {topicArn: topicArn}, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        response.Subscriptions.forEach (subscription) ->
          labels = Object.keys(subscription)
          labels.forEach (label) ->
            msg.send(label + " " + subscription[label])
          msg.send "____________________________________"
