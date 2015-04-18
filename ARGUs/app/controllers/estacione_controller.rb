require 'soap/wsdlDriver'

class EstacioneController < ApplicationController
  before_filter :permisosAdmin, :only => [  :new, :create, :edit, :destroy, :update ]
  before_filter :permisosInv, :only => [ :list, :show, :update ]
  
      
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  
   
 def list   
    @whatami = whatami
     sort = case params[:sort]
               when "Latitud"  then "latitud"
               when "Longitud"   then "longitud"
               when "Pais" then "pais"
               when "Informacion"   then "informacion"
               when "Nombre" then "nombre"
               when "CodigoOMM"   then "codigoOMM"
               when "Altura" then "altura"  
     
               when "Latitud_reverse"  then "latitud DESC"
               when "Longitud_reverse"   then "longitud DESC"
               when "Pais_reverse" then "pais DESC"
               when "Informacion_reverse"   then "informacion DESC"
               when "Nombre_reverse" then "nombre DESC"  
               when "CodigoOMM_reverse"   then "codigoOMM DESC"
               when "Altura_reverse" then "altura DESC"  
             end
      
      @estacione_pages, @estaciones = paginate :estaciones, :order => sort, :per_page => 100 

     if request.xml_http_request?
        render :partial => "list", :layout => false
      end
  end 

  
  
  def auto_complete_for_estacione_nombre
    @estacioneL = Estacione.find(:all, :conditions => ["LOWER(nombre) LIKE ?","%#{params[:estacione][:nombre].downcase}%"], :order => 'nombre ASC')
    render :partial => 'estacNombres'
  end
  
  
  
  def show
    begin
      if (params[:estacione]).nil?
        @estacione = Estacione.find(params[:id])
      else
        @estacione = Estacione.find_by_nombre((params[:estacione][:nombre]).strip.chomp)
        if @estacione.nil?
          raise ActiveRecord::RecordNotFound
        end
      end
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
  end
  
  
  
  def new
    @estacione = Estacione.new
  end

  
  
  def create
    @estacione = Estacione.new(params[:estacione])
    if @estacione.save
      flash[:notice] = 'Estación creada.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  
  def update
    begin
      @estacione = Estacione.find(params[:id])
      if @estacione.update_attributes(params[:estacione])
        flash[:notice] = 'Estación actualizada.'
        redirect_to :action => 'show', :id => @estacione
      else
        render :action => 'edit'
      end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end
  
 
  def georeferenciame
    begin
        info = []
        unless (params[:tipoOperacion].nil?)
           if (params[:tipoOperacion].to_s.eql?("unico"))
             # Consigo la estación
             @estacione = Estacione.find(params[:id]) 
             # Luego, seteo el punto y lo paso al arreglo de puntos para el servicio
             if @estacione.fecha_elim.nil? 
                punto = PuntoInformado.new(@estacione.latitud,@estacione.longitud, "Nombre: #{@estacione.nombre} <br/> Altura: <br/> #{@estacione.altura}",'actual')
             else   
                punto = PuntoInformado.new(@estacione.latitud,@estacione.longitud, "Nombre: #{@estacione.nombre} <br/> Altura: <br/> #{@estacionealtura}",'elim')
             end 
             info << punto
           end

           if (params[:tipoOperacion].to_s.eql?("todasEstaciones"))
             # Se consiguen todas las estaciones
             @estacione = Estacione.find(:all, :conditions => { :actual => 'SI'})
             XSD::Charset.encoding = 'UTF8'
             # Para cada estación, se crean los puntos y se pasan en el arreglo al servicio
             for p in @estacione
               # Sección para meter en "información" lo requerido por el usuario
               data = ""
               unless (params[:to_inform].nil?)
                 data << informar(params[:to_inform][0..6],p.id)
               else
                 data << "<b> Usted no eligió datos a mostrar. </b>"
               end
               # Se crea el punto con la información pedida, y se adjunta al arreglo para el servicio
               if p.fecha_elim.nil?
                  punto = PuntoInformado.new(p.latitud,p.longitud, "Nombre: #{p.nombre} <br/> Información: <br/> #{data}",'actual')
               else
                  punto = PuntoInformado.new(p.latitud,p.longitud, "Nombre: #{p.nombre} <br/> Información: <br/> #{data}",'elim')
               end 
	       info << punto
             end
           end

            if (params[:tipoOperacion].to_s.eql?("estado"))
             # Se buscan las estaciones del estado elegido por el usuario
             @estacione = Estacione.find(:all, :conditions => { :estado_acron => (params[:estado])["acronimo_estado"], :actual => 'SI'} )
             XSD::Charset.encoding = 'UTF8'
             # Para cada estación, se crean los puntos y se pasan en el arreglo al servicio
             for p in @estacione
               # Sección para meter en "información" lo requerido por el usuario
               data = ""
               unless (params[:to_inform].nil?)
                 data << informar(params[:to_inform],p.id)
               else
                 data << "<b> No seleccion&oacute; datos para mostrar. </b>"
               end
               # Se crea el punto con la información pedida, y se adjunta al arreglo para el servicio
               if p.fecha_elim.nil?
                  # puts "CONCHALE!!!" 
		  punto = PuntoInformado.new(p.latitud,p.longitud, "Nombre: #{p.nombre} <br/> Información: <br/> #{data}",'actual')
               else
                  # puts p.fecha_elim 
		  punto = PuntoInformado.new(p.latitud,p.longitud, "Nombre: #{p.nombre} <br/> Información: <br/> #{data}",'elim')
               end 
               info << punto
             end
           end

            if (params[:tipoOperacion].to_s.eql?("ventana"))
              @estacione = Estacione.find(:all, :conditions => {:actual => 'SI'})
               # cambio los puntos para adaptarse al formato
             if (params[:longA].to_f > params[:longB].to_f)
               x1ok = params[:longB].to_f
               x2ok = params[:longA].to_f
             else
               x1ok = params[:longA].to_f
               x2ok = params[:longB].to_f
             end
             if (params[:latA].to_f < params[:latB].to_f)
               y1ok = params[:latB].to_f
               y2ok = params[:latA].to_f
             else
               y1ok = params[:latA].to_f
               y2ok = params[:latB].to_f
             end
             # se busca en todas las estaciones
             for p in @estacione
               # si su ubicación está dentro de la ventana geográfica, entonces se añade a la lista de puntos
               if ( inside(x1ok,y1ok,x2ok,y2ok,p.longitud,p.latitud) == 0 )
               # Sección para meter en "información" lo requerido por el usuario
               data = ""
               unless (params[:to_inform].nil?)
                 data << informar(params[:to_inform][0..6],p.id)
               else
                 data << "<b> Usted no eligió datos para mostrar. </b>"
               end
               # Se crea el punto con la información pedida, y se adjunta al arreglo para el servicio
               if p.fecha_elim.nil?
                  punto = PuntoInformado.new(p.latitud,p.longitud, "Nombre: #{p.nombre} <br/> Información: <br/> #{data}",'actual')
               else
                  # puts p.fecha_elim 
		  punto = PuntoInformado.new(p.latitud,p.longitud, "Nombre: #{p.nombre} <br/> Información: <br/> #{data}",'elim')
               end   
               info << punto
               end
             end
         end
        end
           XSD::Charset.encoding = 'UTF8' 
           wsdlfile = "http://www.argus.cesma.usb.ve/wsdl.xml"     # Ubicacion del WSDL
           driver = SOAP::WSDLDriverFactory.new(wsdlfile).create_rpc_driver   
           @result = driver.georeference(info)
           # Sección de dinamismo para la elección de información
           sql = ActiveRecord::Base.connection()
           sql.begin_db_transaction
           # Se busca en el esquema las columnas de las tablas de estacion
           value = sql.execute("select column_name from information_schema.columns where table_schema='public' and table_name='estaciones'")
           sql.commit_db_transaction
           @columnas = []
           for p in value
              if (!(p.to_s.eql?("id")))
                @columnas << p.to_s
              end
           end
      rescue ActiveRecord::RecordNotFound
          handlingRecordNotFound
       end
   end
  
  
  
   def informar(datos,id)
     sql = ActiveRecord::Base.connection()
     sql.begin_db_transaction
     exec = sql.execute("select #{ datos.join", "} from estaciones where id = '#{id}'")
     count = 0
     data = ""
     for resultado in exec
        for re in resultado
           data << "<b>#{datos[count]}</b> : #{re} <br/> "
           # puts re 
           count = count + 1
        end
     end
     sql.commit_db_transaction
     return data
   end

end
