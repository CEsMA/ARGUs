class GeoreferenceApi < ActionWebService::API::Base
   api_method :georeference,
     :expects => [[PuntoInformado]],
     :returns => [{:greeting => :string}]
end


