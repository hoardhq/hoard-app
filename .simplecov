require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::Codecov,
]
SimpleCov.start 'rails' do
  add_group 'Interactors',  '/app/interactors'
  add_group 'Jobs',         '/app/jobs'
end
