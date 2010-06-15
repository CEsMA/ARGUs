class AreaintereseController < ApplicationController
  before_filter :permisosAdmin, :only => [ :list, :new, :create, :edit, :destroy, :show, :update ]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

         
         
  def list
    @areainterese_pages, @areaintereses = paginate :areaintereses, :per_page => 10
  end

  
  
  
  def show
    begin
      @areainterese = Areainterese.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end  
  end

  
  
  
  def new
    @areainterese = Areainterese.new
  end
  
  

  def create
    @areainterese = Areainterese.new(params[:areainterese])
    if @areainterese.save
      flash[:notice] = 'Area de interés creada'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  
  
  
  def edit
    begin
      @areainterese = Areainterese.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
  end

  
  
  
  def update
    begin
      @areainterese = Areainterese.find(params[:id])
      if @areainterese.update_attributes(params[:areainterese])
        flash[:notice] = 'Area de interés actualizada de forma exitosa.'
        redirect_to :action => 'list'
      else
        render :action => 'edit'
      end
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
  end

  
  
  
  def destroy
    begin
      Areainterese.find(params[:id]).destroy
      redirect_to :action => 'list'
    rescue ActiveRecord::RecordNotFound
      handlingRecordNotFound
    end
  end
  
  
  
  
  def destroyMultiple
    permisosAdmin
     if request.post?
      if params[:to_delete].nil?
        flash[:notice] = 'Recuerde seleccionar al menos un área de interés.'
      else 
        #find all requested records
        areas  = params[:to_delete].map { |r| Areainterese.find_by_id(r) }
        #make sure you are only working with records that exist
        areas.delete(nil)
        #destroy valid records
        areas.each { |r| r.destroy }
      end
        redirect_to :action => 'list'
        
    end
  end
end
