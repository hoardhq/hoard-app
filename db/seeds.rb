Stream.destroy_all
User.destroy_all

User.create!(email: 'user@example.com', password: 'password')

Stream.create!(name: 'Example #1', slug: 'example-1')
Stream.create!(name: '/dev/null', slug: 'devnull')

# Access Log Stream
stream = Stream.create(name: 'Access Log', slug: 'accesslog')
(1..1000).each do |n|
  stream.events.create(
    data: {
      uuid: "#{n.to_s.ljust 4, '0'}-#{(rand * 10000000).ceil.to_s.ljust 8, '0'}",
      host: "s#{(rand * 10).ceil}.example.org",
      path: "/users/#{(rand * 10000).ceil}",
      status: [200, 301, 302, 404, 500, 503].sample,
    }
  )
end
