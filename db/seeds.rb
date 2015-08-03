Stream.destroy_all
User.destroy_all

puts "Creaintg Users"
User.create!(email: 'user@example.com', password: 'password')

puts "Creating Streams"
Stream.create!(name: 'Example #1', slug: 'example-1')
Stream.create!(name: '/dev/null', slug: 'devnull')

# Access Log Stream
stream = Stream.create(name: 'Access Log', slug: 'accesslog')
puts "Creating Events"
(0..999).each do |n|
  print "."
  puts "" if n % 100 == 99
  stream.events.create(
    data: {
      uuid: SecureRandom.uuid,
      host: "s#{(rand * 10).ceil}.example.org",
      path: "/users/#{(rand * 10000).ceil}",
      status: [200, 301, 302, 404, 500, 503].sample,
    }
  )
end
