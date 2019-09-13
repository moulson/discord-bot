desc "Start discord bot"
task :start_bot => :environment do
	BotController.start_bot
end