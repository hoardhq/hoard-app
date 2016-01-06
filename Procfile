web: bundle exec puma -t ${MAX_THREADS:-4}:${MAX_THREADS:-4} -w ${WEB_CONCURRENCY:-1} -e ${RACK_ENV:-development} -b ${PUMA_BIND:-tcp://localhost:5000}
job: bundle exec sidekiq -c 1
clock: bundle exec clockwork config/clockwork.rb
