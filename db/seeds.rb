Stream.destroy_all

Stream.create(name: 'Example #1', slug: 'example-1')
Stream.create(name: '/dev/null', slug: 'devnull')

# Access Log Stream
stream = Stream.create(name: 'Access Log', slug: 'accesslog')
(1..100).each do |n|
  stream.events.create(
    data: {
      uuid: "#{n.to_s.ljust 4, '0'}-#{(rand * 10).ceil.to_s.ljust 8, '0'}",
      host: "s#{(rand * 10).ceil}.example.org",
      path: "/users/#{(rand * 10000).ceil}",
    }
  )
end
