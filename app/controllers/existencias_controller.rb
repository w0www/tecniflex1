class ExistenciasController < ApplicationController

  hobo_model_controller

  auto_actions :all
  auto_actions_for :bodega, [:create, :new]

=begin
  def new

        @origo = params[:existencia] || {}
        @genic = @origo
        @genic.delete(:cantidad)
        if @origo[:cantidad]
          @qant = @origo[:cantidad]
          if @qant > 1
            @qant.downto(1) do |x|
              @genic.store(:cantidad,1)
              hobo_new Existencia.new(@genic) do
                this.attributes = params[:existencia] || {}
                hobo_ajax_response if request.xhr?
              end
            end
          else
              hobo_new Existencia.new(@origo) do
                this.attributes = params[:existencia] || {}
                hobo_ajax_response if request.xhr?
              end
          end
        end


  end
=end
    def creaex
      @exis = params[:existencia]
      @qant = @exis[:cantidad] || 1
      @exis.delete(:cantidad)
      @exis.store(:cantidad,1)
      @qant.downto(1) do |x|
        hobo_new Existencia.new(@exis)
      end
    end



end

