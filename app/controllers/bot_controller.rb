class BotController < ApplicationController
    require 'discordrb'
    require 'json'
    require 'net/http'
    require 'open-uri'
    
    #GET bot/run
    def run
        
    end

    def get_status

    end

    def kill

    end

    def self.download_youtube(url, title)
        video = YoutubeDL::Video.new(url)
        video.options.configure do |c|
            c.output = "#{Rails.root}/app/assets/music/#{title.gsub(' ', '_').gsub('.','').downcase}.mp3"
            c.extract_audio = true
            c.audio_format = 'mp3'
        end
        video.download
    end

    def start
        call_rake :start_bot
        flash[:notice] = "Bot has been started"
    end

    def self.start_bot
        bot = Discordrb::Commands::CommandBot.new token: ENV["DISCORD_BOT_TOKEN"], client_id: ENV["MASTER_USER_ID"], prefix: '!'
        bot.playing do |event|
            bot.send_message(event.channel.id, "playing")
        end

        bot.command :d20 do |event|
            r = Random.new
            bot.send_message(event.channel.id, r.rand(1...20).to_s)
        end

        bot.command :ping do |event|
            event.respond 'Pong!'
        end

        bot.command :summon do |event|
            break unless event.user.id == 137281612818677761

            channel = event.user.voice_channel

            next "no channel" unless channel

            bot.voice_connect(channel)
            "Connected to voice channel: #{channel.name}"
        end

        bot.command :stop do
            bot.stop
        end

        bot.run
    end

    def kill_bot
        bot.end
    end
end