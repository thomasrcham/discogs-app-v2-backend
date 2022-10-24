require "net/http"
require "open-uri"
require "json"

class Album < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  has_many :listen_events

  def genres
    genre_id.split(", ").map { |g| Genre.find(g)["name"] }.join(", ")
  end

  def update_year
    if needs_year_update
      uri = URI.parse(master_album_url)
      response = Net::HTTP.get_response(uri)
      data = JSON.parse(response.body)
      update(year: data["year"], needs_year_update: false)
    else
      "does not need"
    end
  end
end
