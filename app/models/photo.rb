# We assume our app will possess its own photos and integrate with a few photo share communities
# Thus, photo model defines the standard structure a photo should hold
# No matter where it comes from, i.e. stored in our database or fetched from other sources like 500px
# (If a photo comes from external source, we would only build it in memory without persistence)
# Since we parse photo structure (considering various sources) in server side
# Front end UI becomes easy to build
class Photo
  # 'class Photo < ActiveRecord::Base' seems overkill for current need (since no persistence)
  # We use a plain ruby class for uni-structure purpose
  attr_accessor :source, :source_id, :name, :description, :rating, :image_url

  FivehundredPX = "500px"

  def setup_from_fivehundredpx(photo)
    return if photo.blank?
    self.source      = FivehundredPX
    self.source_id   = photo[:id]
    self.name        = photo[:name]
    self.description = photo[:description]
    self.rating      = photo[:rating]
    self.image_url   = photo[:image_url]
  end

  def from_fivehundredpx?
    self.source == FivehundredPX
  end

  def as_json(options)
    super(options).reject{|k,v| k=="description"}
  end
end
