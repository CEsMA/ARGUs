class ReportepentahosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    if current_usuario.tipo == 'Investigador' then
      if params[:tipo] == "propios" then
     # join de la solicitud y el reporte resuelto (estatus 3) de una solicitud hecha por el usuario conectado
        @reportepentaho_pages, @reportepentahos = paginate(:solicitudreportes, :select => 'titulo, comentario, link', :conditions => "status = 3", :per_page => 20, :joins =>
            "JOIN reportepentahos ON solicitudreportes.id = reportepentahos.solicitudreporte_id AND
              usuario_id = '#{current_usuario.id}'")
      end
      if params[:tipo] == "publicos" then
     # join de la solicitud y el reporte resuelto (status 3) de caracter publico
        @reportepentaho_pages, @reportepentahos = paginate(:solicitudreportes, :select => 'titulo, comentario, link', :conditions => "status = 3", :per_page => 20, :joins =>
            "JOIN reportepentahos ON solicitudreportes.id = reportepentahos.solicitudreporte_id AND
              privado = FALSE")
      end
    end
    if current_usuario.tipo == 'Consultor' then
       if params[:tipo] == "resueltospormi" then
     # join de la solicitud y el reporte resuelto (status 3) de caracter publico
        @reportepentaho_pages, @reportepentahos = paginate(:solicitudreportes, :select => 'titulo, comentario, link', :conditions => "status = 3", :per_page => 20, :joins =>
            "JOIN reportepentahos ON solicitudreportes.id = reportepentahos.solicitudreporte_id AND
              consultor_id = '#{current_usuario.id}'")
       end
       if params[:tipo] == "todos" then
     # join de la solicitud y el reporte resuelto (status 3) de caracter publico
        @reportepentaho_pages, @reportepentahos = paginate(:solicitudreportes, :select => 'titulo, comentario, link', :conditions => "status = 3", :per_page => 20, :joins =>
            "JOIN reportepentahos ON solicitudreportes.id = reportepentahos.solicitudreporte_id")
       end
    end
        
        #@solicitudreporte_pages, @solicitudreportes = paginate(:reportepentahos, :per_page => 20)
  
    #@reportepentaho_pages, @reportepentahos = paginate :reportepentahos, :per_page => 10
    @cantidad = 0
    for a in @reportepentahos
      @cantidad = @cantidad +1
    end
    if @cantidad == 0 then @nohay = true end
    if @cantidad >=1 then @nohay = false end
  end

  def show
    @reportepentaho = Reportepentaho.find(params[:id])
  end

  def new
    @reportepentaho = Reportepentaho.new
    @sol = params[:solicitud]
    @solid = Integer(@sol)
  end

  def create
    @reportepentaho = Reportepentaho.new(params[:reportepentaho])
    @reportepentaho.usuarios_id = current_usuario.id
    @reportepentaho.solicitudreporte_id = params[:solicitud]
    @solcambia = Solicitudreporte.find(params[:solicitud])
    @solcambia.status = 3
    @solcambia.save
    if @reportepentaho.save
      flash[:notice] = 'El reporte fue publicado exitosamente.'
      redirect_to :controller => 'solicitudreportes', :action => 'menu'
    else
      render :action => 'new'
    end
  end

  def edit
    @reportepentaho = Reportepentaho.find(params[:id])
  end

  def update
    @reportepentaho = Reportepentaho.find(params[:id])
    if @reportepentaho.update_attributes(params[:reportepentaho])
      flash[:notice] = 'Reportepentaho was successfully updated.'
      redirect_to :action => 'show', :id => @reportepentaho
    else
      render :action => 'edit'
    end
  end

  def destroy
    Reportepentaho.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
