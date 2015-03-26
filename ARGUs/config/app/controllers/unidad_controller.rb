class UnidadController < ApplicationController
  before_filter :permisosAdmin, :only => [ :list, :new, :create, :edit, :destroy, :show, :update ]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @unidad_pages, @unidads = paginate :unidads, :per_page => 10
  end

  def show
    begin
      @unidad = Unidad.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
  end

  
  
  def new
    @unidad = Unidad.new
  end

  
  
  def create
    @unidad = Unidad.new(params[:unidad])
    if @unidad.save
      flash[:notice] = 'Unidad creada.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  
  
  def edit
    begin
       @unidad = Unidad.find(params[:id])
    rescue ActiveRecord::RecordNotFound
       handlingRecordNotFound
    end    
  end

  
  
  def update
    begin
      @unidad = Unidad.find(params[:id])
      if @unidad.update_attributes(params[:unidad])
        flash[:notice] = 'Unidad actualizada.'
        redirect_to :action => 'show', :id => @unidad
      else
        render :action => 'edit'
      end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  def destroy
    begin
      Unidad.find(params[:id]).destroy
      redirect_to :action => 'list'
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end 
  end
end
