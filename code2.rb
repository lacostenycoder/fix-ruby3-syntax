def junk({foo: nil, bar: nil})
# broken
    html = ApplicationController.render(
      partial: "user_messages/#{user_message.message.message_type}",
      locals:  { user_message: user_message },
      formats: [:html]
    )

# fixed
    html = ApplicationController.render({
      partial: "user_messages/#{user_message.message.message_type}",
      locals:  { user_message: user_message },
      formats: [:html],
      something: {this: :might_break}
    })
end

def foo({bar:, opts={})
end
