class RequerimientoController < ApplicationController
  before_filter :permisosAdmin, :only => [ :list, :new, :create, :edit, :destroy, :show, :update ]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @requerimiento_pages, @requerimientos = paginate :requerimientos, :per_page => 10
  end

  def show
    begin
      @requerimiento = Requerimiento.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
  end


  def new
    @requerimiento = Requerimiento.new
  end

  
  
  def create
    @requerimiento = Requerimiento.new(params[:requerimiento])
    if @requerimiento.save
      flash[:notice] = 'Requerimiento creado exitosamente.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  
  
  def edit
    begin
      @requerimiento = Requerimiento.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  
  def update
    begin
      @requerimiento = Requerimiento.find(params[:id])
      if @requerimiento.update_attributes(params[:requerimiento])
        flash[:notice] = 'Requerimiento actualizado.'
        redirect_to :action => 'show', :id => @requerimiento
      else
        render :action => 'edit'
      end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  def destroy
    begin
      Requerimiento.find(params[:id]).destroy
      redirect_to :action => 'list'
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end
end
