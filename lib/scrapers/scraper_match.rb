# frozen_string_literal: true

module Scrapers
  class ScraperMatch
    attr_accessor :match

    def initialize(match)
      @match = match
    end

    def datetime
      return @datetime if @datetime
      datetime = @match.css('.fi-mu__info__datetime')&.text&.strip
      datetime = datetime&.downcase&.gsub('local time', '')&.strip&.to_time
      @datetime = datetime
    end

    def venue
      @venue ||= @match.css('.fi__info__venue')&.text
    end

    def location
      @location ||= @match.css('.fi__info__stadium')&.text
    end

    def home_team_code
      @home_team_code ||= @match.css('.home .fi-t__nTri')&.text
    end

    def away_team_code
      @away_team_code ||= @match.css('.away .fi-t__nTri')&.text
    end

    def match_status
      return @match_status if @match_status
      status = if @match.attributes['class']&.value&.include?('live')
                 'in progress'
               elsif @match.css('.period')&.css(':not(.hidden)')
                  &.text&.downcase&.include?('full-time')
                 'end of time'
               else
                 'undetermined'
               end
      @match_status = status
    end
  end
end
