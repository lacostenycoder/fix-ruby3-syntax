# frozen_string_literal: true
desc 'one' 
task one: :environment do
  RakeJob.perform_later('qapps:financials:max_completed_at')
  RakeJob.perform_later('db:sessions:trim')
end

desc :test_task 
task are_you_peaking: :environment do
  def method_good(foo)
    puts :foo
  end
end