class ConsultatagController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @consultatag_pages, @consultatags = paginate :consultatags, :per_page => 10
  end

  
  
  def show
    begin
       @consultatag = Consultatag.find(params[:id])
    rescue ActiveRecord::RecordNotFound
       handlingRecordNotFound
    end
  end

  
  
  def new
    @consultatag = Consultatag.new
  end

  
  
  def create
    @consultatag = Consultatag.new(params[:consultatag])
    if @consultatag.save
      flash[:notice] = 'Consultatag was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  
  
  def edit
    begin
      @consultatag = Consultatag.find(params[:id])
    rescue ActiveRecord::RecordNotFound
       handlingRecordNotFound
    end
  end

  
  
  def update
    begin
      @consultatag = Consultatag.find(params[:id])
        if @consultatag.update_attributes(params[:consultatag])
          flash[:notice] = 'Consultatag was successfully updated.'
          redirect_to :action => 'show', :id => @consultatag
        else
          render :action => 'edit'
        end
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end
  end

  
  
  def destroy
    begin
      Consultatag.find(params[:id]).destroy
      redirect_to :action => 'list'
    rescue ActiveRecord::RecordNotFound
        handlingRecordNotFound
    end

  end
end
