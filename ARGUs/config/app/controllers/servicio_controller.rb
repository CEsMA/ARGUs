class ServicioController < ApplicationController
  before_filter :permisosProv, :only => [  :new, :create, :edit, :update ]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :destroyMultiple ],
         :redirect_to => { :action => :list }

  
  def list
    @whatami = whatami
      sort = case params[:sort]
               when "Nombre"  then "nombre"
               when "Descripcion"   then "descripcion"
               when "Autor" then "autor"
               when "Habilitado"  then "habilitado"
                 
               when "Nombre_reverse"  then "nombre DESC"
               when "Descripcion_reverse"   then "descripcion DESC"
               when "Autor_reverse" then "autor DESC"
               when "Habilitado_reverse"  then "habilitado DESC"                    
             end

    @servicio_pages, @servicios = paginate :servicios, :per_page => 10, :order => sort, :select => "id,nombre, descripcion,habilitado,autor,usuario_id"
   
     if request.xml_http_request?
        render :partial => "list", :layout => false
      end
  end
  
  
  
  def show
   begin
      @servicio = Servicio.find(params[:id])
   rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
   end
  end

  
  
  def new
    @servicio = Servicio.new 
  end

  
  
  
  def create
    @servicio = Servicio.new(params[:servicio])
    @servicio.usuario_id = current_usuario.id
    
    @servicio.tags =  @servicio.tags.to_s.downcase.slice(0,255)
    @servicio.descripcion =  @servicio.descripcion.to_s.slice(0,200)
    puts params[:servicio][:habilitado]
    @servicio.habilitado = params[:servicio][:habilitado]
    if @servicio.save
      flash[:notice] = 'Servicio creado.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  

  def edit
    begin
      @servicio = Servicio.find(params[:id])
      if current_usuario.tipo.eql?("Administrador") || @servicio.usuario_id == current_usuario.id
        # todo está bien... que siga editando! :D
      else 
         flash[:error_input] = 'Usted no puede editar un servicio que no es suyo.'
         redirect_to :action => 'list', :id => @servicio
      end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end
  
  

  def update
    begin
      @servicio = Servicio.find(params[:id])
      @servicio.tags =  @servicio.tags.to_s.downcase.slice(0,255)
      @servicio.descripcion =  @servicio.descripcion.to_s.slice(0,200)
        if @servicio.update_attributes(params[:servicio])
          flash[:notice] = 'Servicio actualizado con exito.'
          redirect_to :action => 'show', :id => @servicio
        else
          render :action => 'edit'
        end

    
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  
  def destroy
    begin
      if Servicio.find(params[:id]).habilitado
        flash[:error_input] = 'Usted no puede eliminar un servicio habilitado.'
        redirect_to :action => list
      else
        Servicio.find(params[:id]).destroy
        redirect_to :action => 'list' 
      end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
   end
   
   
   
   def destroyMultiple
     if request.post?
      if params[:to_delete].nil?
        flash[:notice] = 'Debe seleccionar al menos un servicio.'
      else 
        #find all requested records
        servicios  = params[:to_delete].map { |r| Servicio.find_by_id(r) }
        #make sure you are only working with records that exist
        servicios.delete(nil)
        #destroy valid records
        flash[:notice] = 'Si algun servicio seleccionado no fue borrado, se debe a que este se encuentra habilitado. Deshabilitelo para poder borrarlo'
        servicios.each { |r| r.destroy if !r.habilitado }
      end
        redirect_to :action => 'list'
    end
  end
  
  
   def busquedaservicios
     servicios = Servicio.find(:all)
     @whatami = whatami
     @servicios = []
      if (params[:patron].nil? || params[:patron]=="")
         flash[:notice] = 'Debe especificar una palabra clave.'
         redirect_to :action => 'list'
      else

        for servicio in servicios  
          if servicio.habilitado?
   unless busquedaPatrones(servicio.tags << " " << servicio.nombre << " " << servicio.descripcion,params[:patron].downcase,params[:opcion].to_i).nil?
              @servicios << servicio
           end
          end
         end
         if @servicios.empty?
           flash[:notice] = "No hay servicios habilitados relacionados con la palabra clave ingresada."
           redirect_to :action => 'list'
         else
           @tag = params[:patron].downcase
         end
     end
  end
  
  
end
