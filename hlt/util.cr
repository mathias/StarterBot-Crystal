class Util
  def self.angle_rad_to_deg_clipped(num)
    (num * 180.0 / Math::PI).round.modulo(360)
  end
end
