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
      formats: [:html]
    })
end

def foo(bar:, opts={})
end

def math(x, y)
  puts '10:00'
  100 * 2 * 2 + ( x * y)
end

def foobar
  {'foo' => :bar}
end