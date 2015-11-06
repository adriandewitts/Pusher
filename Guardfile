guard 'bundler' do
  watch('Gemfile')
end

guard 'spin' do
  # uses the .rspec file
  # --colour --fail-fast --format documentation --tag ~slow
  watch(%r{^spec/.+_spec\.rb})
  watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)\.haml})                         { |m| "spec/#{m[1]}.haml_spec.rb" }
  watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }
  watch(%r{^config/routes.rb})  { |m| ["spec/routing/*.rb"] }
end

guard 'passenger', cli: '--daemonize --port 3001' do
  watch(/^lib\/.*\.rb$/)
  watch(/^config\/.*\.rb$/)
end


  