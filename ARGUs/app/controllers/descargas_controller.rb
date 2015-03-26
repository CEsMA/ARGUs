class DescargasController < ApplicationController
   def descargaArchivo
      nombrefile = params[:nombrefile]
      
      begin
        send_file("#{nombrefile}",
                  :filename      =>  "#{nombrefile}",
                  :type             =>  'text',
                  :disposition  =>  'attachment',
                  :streaming    =>  'false',
                  :buffer_size  =>  2048)
      rescue
        flash[:notice] = "El archivo solicitado no fue encontrado en el sistema."
        redirect_to :back
      end
   end
end