class PuntoInformado < ActionWebService::Struct
  member :latitud, :string
  member :longitud, :string
  member :informacion, :string
  member :color, :string
  
  def initialize(lat,lon,info,col)
    @latitud = lat
    @longitud = lon
    @informacion = info
    @color = col 
  end
  
  def to_s
    @latitud << " " << @longitud << " " << @informacion << " " << @color
  end
end
