namespace :schedule_mail do
  task :send, [:enrollment_id] => :environment do |task, args|
    puts "I am from rake"
    enrollment_id = args[:enrollment_id]
    SendScheduleMail.perform_in(30.second,enrollment_id)
  end
end
