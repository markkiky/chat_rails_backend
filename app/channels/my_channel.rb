class MyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "my_channel_#{current_user.id}"
    puts "We are live and streaming"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def some_method(args)
    args = args["some_args"]
    puts args

    ActionCable.server.broadcast \
      "my_channel_1", { title: "New things!", body: "All that's fit for print" }
  end
end

# JSON String to Subscribe to channel
# {
#   "command": "subscribe",
#   "identifier": "{\"channel\":\"MyChannel\"}"
# }

# JSON TO CALL SOME METHOD
{
  "command": "message",
  "identifier": "{\"channel\":\"MyChannel\"}",
  "data": "{\"action\":\"some_method\", \"some_args\":\"args\"}"
}
