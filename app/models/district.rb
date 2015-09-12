class District < ActiveRecord::Base
  validates_presence_of :name
  before_create :set_coord

  def self.search(search)
    if search
      where('lower(name) LIKE ?', "%#{search.downcase}%")
    else
      all
    end
  end

  private
  def set_coord
    if self.lat.blank? && self.lon.blank?
      url = "https://geocode-maps.yandex.ru/1.x/?format=json&geocode=#{self.name.split.join('+')}&ll=30.327541,59.936952&spn=2,2&rspn=1"
      response = JSON.parse(Net::HTTP.get_response(URI.parse(URI.encode(url))).body)
      self.lon, self.lat =
        if response['response']['GeoObjectCollection']['featureMember'].present?
          response['response']['GeoObjectCollection']['featureMember'][0]['GeoObject']['Point']['pos'].split
        else
          [0,0]
        end
    end
  end
end
