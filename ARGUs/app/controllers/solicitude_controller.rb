class SolicitudeController < ApplicationController
  before_filter :permisosProv, :only => [  :new, :create ]
  before_filter :permisosAdmin, :only => [ :list, :show, :update ]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create ],
         :redirect_to => { :action => :list }

  
  def list
    if params[:tipo].nil?
        #Historico
        @tipo = "historico"
        @solicitude_pages, @solicitudes = paginate :solicitudes, :per_page => 10
    else
        @tipo = "por atender"
        @solicitudes = Solicitude.find(:all, :conditions => 'atendido_por = 0')
        #Unicamente aquellas que no hayan sido atendidas.
    end
  end
  
  
    
  def show
    begin
      @solicitude = Solicitude.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  
  def new
    @solicitude = Solicitude.new
  end
  
  

  def create
    @solicitude = Solicitude.new(params[:solicitude])
    @solicitude.atendido_por = 0
    @solicitude.solicitante = current_usuario.id
    if @solicitude.save
      flash[:notice] = 'Solicitud creada.'
      redirect_to :action => 'new'
    else
      render :action => 'new'
    end
  end

  
  def update
    begin
      @solicitude = Solicitude.find(params[:id])
      @solicitude.atendido_por = current_usuario.id
      if @solicitude.update_attributes(params[:solicitude])
        flash[:notice] = 'Solicitud actualizada.'
        redirect_to :action => 'list'
      else
        render :action => 'list'
      end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end
end
