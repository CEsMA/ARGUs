class SolicitudreportesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @solicitudreporte_pages, @solicitudreportes = paginate(:solicitudreportes, :conditions => "status = 999", :per_page => 20)
    #Con esto se busca que al menos se envie la lista vacia para no generar errores. 
    if current_usuario.tipo == 'Investigador' then
      @solicitudreporte_pages, @solicitudreportes = paginate(:solicitudreportes, :conditions => "usuario_id = '#{current_usuario.id}' and status = 1", :per_page => 20)
    end
    if current_usuario.tipo == 'Consultor' then
       if params[:tipo] == "espera" then
          @solicitudreporte_pages, @solicitudreportes = paginate(:solicitudreportes, :conditions => "status = 1", :per_page => 20)
       end
       if params[:tipo] == "asignadas" then 
          @solicitudreporte_pages, @solicitudreportes = paginate(:solicitudreportes, :conditions => "consultor_id = '#{current_usuario.id}' AND status = 2", :per_page => 20)
       end
       if params[:tipo] == "resueltas" then 
          @solicitudreporte_pages, @solicitudreportes = paginate(:solicitudreportes, :conditions => "status = 3", :per_page => 20)
       end
       if params[:tipo] == "resueltaspormi" then
          @solicitudreporte_pages, @solicitudreportes = paginate(:solicitudreportes, :conditions => "consultor_id = '#{current_usuario.id}' AND status = 3", :per_page => 20)
       end
    end
    @cantidad = 0
    for a in @solicitudreportes
      @cantidad = @cantidad +1
    end
  end

  #Accion para listarle al Consultor aquellas solicitudes que esperan por ser resueltas.

  def listenespera
    if current_usuario.tipo == 'Consultor' then
       @solicitudreporte_pages, @solicitudreportes = paginate(:solicitudreportes, :conditions => "consultor_id = NULL", :per_page => 20)
    end
  end

  def listarasignadas
    if current_usuario.tipo != 'Consultor' then
      redirect_to :action => 'list'
    end
    if current_usuario.tipo == 'Consultor' then

    end
  end

  def show
    @solicitudreporte = Solicitudreporte.find(params[:id])
  end

  def new
    @solicitudreporte = Solicitudreporte.new
  end

  def create
    @solicitudreporte = Solicitudreporte.new(params[:solicitudreporte])
    @solicitudreporte.creacion = Time.now
    @solicitudreporte.status = 1
    @solicitudreporte.estado = params[:estado][:nombre]
    #@solicitudreporte.estacion = params[:estacion][:codigo_omm]
    @solicitudreporte.usuario_id = current_usuario.id
    if @solicitudreporte.save
      flash[:notice] = 'Su solicitud fue creada exitosamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @solicitudreporte = Solicitudreporte.find(params[:id])
  end

  def update
    @solicitudreporte = Solicitudreporte.find(params[:id])
    if @solicitudreporte.update_attributes(params[:solicitudreporte])
      flash[:notice] = 'Solicitudreporte was successfully updated.'
      redirect_to :action => 'show', :id => @solicitudreporte
    else
      render :action => 'edit'
    end
  end

  def asignar
    @solicitudreporte = Solicitudreporte.find(params[:id])
    @solicitudreporte.consultor_id = current_usuario.id
    @solicitudreporte.status = 2
    @solicitudreporte.save
    redirect_to :action => 'list'
  end

  def menu
    #No hace falta preparar ningun dato pues es unicamente una lista de opciones
  end

  def destroy
    Solicitudreporte.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
