require 'jekyll'
require 'shellwords'

class YouTubeEmbed < Liquid::Tag

  def initialize(tag_name, markup, tokens)
    super
    params = Shellwords.shellwords markup
    @items = { :url => params[0] }
  end

  def render(context)
    youtube_url = "#{@items[:url].strip}"
    if youtube_url[/youtu\.be\/([^\?]*)/]
      @youtube_id = $1
    else
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      @youtube_id = $5
    end

      %Q{<div class='embed-container'><iframe width="640" height="390" src="//www.youtube.com/embed/#{@youtube_id}" frameborder="0" allowfullscreen></iframe></div>}
  end

  Liquid::Template.register_tag "youtube", self
end


class TwitchEmbed < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
      params = Shellwords.shellwords markup
      @items = { :url => params[0], :type => params[1] || "channel", :aplay => params[2] || false }
    end
  
    def render(context)
      tstr = "#{@items[:url].strip}"

      case @items[:type]
        when "channel" || "0"
          if tstr[/twitch\.tv\/([^\?]*)/]
            @twitch_url = $1
          else
            @twitch_url = "#{@items[:url]}"
          end
          %Q{<div class='embed-container'><iframe src="https://player.twitch.tv/?channel=#{@twitch_url}" frameborder="0" allowfullscreen="true" scrolling="no" autoplay="#{@items[:aplay]}" height="390" width="640"></iframe></div>}

        when "video" || "1"
          if tstr[/twitch\.tv\/videos\/([^\?]*)/]
            @twitch_url = $1
          else
            @twitch_url = "#{@items[:url]}"
          end
          %Q{<div class='embed-container'><iframe src="https://player.twitch.tv/?video=#{@twitch_url}&autoplay=#{@items[:aplay]}" frameborder="0" allowfullscreen="true" scrolling="no" autoplay="#{@items[:aplay]}" height="390" width="640"></iframe></div>}

        when "clip" || "2"
          if tstr[/clips\.twitch\.tv\/([^\?]*)/]
            @twitch_url = $1
          elsif tstr[/twitch\.tv\/([^\?]*)\/clip\/([^\?]*)\?/]
            @twitch_url = $2
          else
            @twitch_url = "#{@items[:url]}"
          end
          %Q{<div class='embed-container'><iframe src="https://clips.twitch.tv/embed?clip=#{@twitch_url}&autoplay=#{@items[:aplay]}" frameborder="0" allowfullscreen="true" scrolling="no" autoplay="#{@items[:aplay]}" height="390" width="640"></iframe></div>}

        else
          ""
        end
    end
  
    Liquid::Template.register_tag "twitch", self
end

class VimeoEmbed < Liquid::Tag

    def initialize(tagName, content, tokens)
      super
      @content = content
    end
  
    def render(context)
      vimeo_url = "#{context[@content.strip]}"
      if vimeo_url[/vimeo\.com\/([^\?]*)/]
        @vimeo_id = $1
      end
        %Q{<div class='embed-container'><iframe src="https://player.vimeo.com/video/#{@vimeo_id}" frameborder="0" allowfullscreen="true" scrolling="no" height="390" width="640"></iframe></div>}
    end
  
    Liquid::Template.register_tag "vimeo", self
end



class SoundCloudEmbed < Liquid::Tag

  def initialize(tag_name, markup, tokens)
    super
    params = Shellwords.shellwords markup
    @items = { :id => params[0], :color => params[1] || "ff7700", :aplay => params[2] || false }
  end

  def render(context)
    %Q{<div class="embed-container"><iframe width="100%" height="166" scrolling="no" frameborder="no" src="//w.soundcloud.com/player/?url=//api.soundcloud.com/tracks/#{@items[:id]}&color=%23#{@items[:color]}&auto_play=#{@items[:aplay]}&hide_related=true&show_comments=false&show_reposts=false&show_teaser=false"></iframe></div>}
  end

  Liquid::Template.register_tag "soundcloud", self
end



class SpotifyEmbed < Liquid::Tag

  def initialize(tag_name, markup, tokens)
    super
    params = Shellwords.shellwords markup
    @items = { :url => params[0] }
  end

  def render(context)
    spotify_url = "#{@items[:url].strip}"

    if spotify_url[/open\.spotify\.com\/((embed\/?)?)([^\?]*)/]
      @spotify_id = $3
    else
      @spotify_id = "track/#{@items[:url]}"
    end
    %Q{<div class="embed-container"><iframe width="100%" height="166" scrolling="no" frameborder="no" src="//embed.spotify.com/?uri=#{@spotify_id}"></iframe></div>}
  end

  Liquid::Template.register_tag "spotify", self
end