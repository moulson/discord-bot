class BotController < ApplicationController
    require 'discordrb'
    require 'json'
    require 'net/http'
    require 'open-uri'
    
    BOT = Discordrb::Commands::CommandBot.new token: ENV["DISCORD_BOT_TOKEN"], client_id: ENV["MASTER_USER_ID"], prefix: '!'

    def get_status

    end

    def kill
        path = "#{Rails.root}/tmp/botpid.txt"
        if File.exists? path
            pid = File.read(path)
            system "kill -9 #{pid}"
            File.delete path
        end
        render json: "Done!"
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
        BOT.playing do |event|
            BOT.send_message(event.channel.id, "playing")
        end

        BOT.command :d20 do |event|
            r = Random.new
            BOT.send_message(event.channel.id, r.rand(1...20).to_s)
        end

        BOT.command :ping do |event|
            event.respond 'Pong!'
        end

        BOT.command :summon do |event|
            break unless event.user.id == 137281612818677761

            channel = event.user.voice_channel

            next "no channel" unless channel

            BOT.voice_connect(channel)
            "Connected to voice channel: #{channel.name}"
        end

        BOT.command :stop do
            if File.exists? "#{Rails.root}/tmp/botpid.txt"
                File.delete("#{Rails.root}/tmp/potpid.txt")
            end
            BOT.stop
        end

        #Only allow one bot to be running at once
        if not File.exists? "#{Rails.root}/tmp/botpid.txt"
            File.open("#{Rails.root}/tmp/botpid.txt","w"){|file| file.puts Process.pid}
            BOT.run
        end
    end

    
end