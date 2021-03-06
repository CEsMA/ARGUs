class EstadoController < ApplicationController
  before_filter :permisosAdmin, :only => [ :list, :new, :create, :edit, :destroy, :show, :update ]
  
  def index
    list
    render :action => 'list'
  end

  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

         
         
  def list
    @estado_pages, @estados = paginate :estados, :per_page => 10
  end

  
  
  def show
    begin
      @estado = Estado.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  
  def new
    @estado = Estado.new
  end

  
  
  
  def create
    @estado = Estado.new(params[:estado])
    if @estado.save
      flash[:notice] = 'Estado creado.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  
  
  def edit
    begin
      @estado = Estado.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  
  
  def update
    begin
      @estado = Estado.find(params[:id])
      if @estado.update_attributes(params[:estado])
        flash[:notice] = 'Estado actualizado.'
        redirect_to :action => 'show', :id => @estado
      else
        render :action => 'edit'
      end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  
  
  def destroy
    begin
      Estado.find(params[:id]).destroy
      redirect_to :action => 'list'
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end
end
