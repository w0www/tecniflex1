class Movimiento < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    cantidad :integer
    tipo enum_string(:'Ingreso', :'Egreso')
    lote :string
    serie :string
    timestamps
  end

  belongs_to :mov_header
  belongs_to :bodega
  belongs_to :ord_trab
  belongs_to :user
  belongs_to :polimero

  #validate_presence_of :bodega_id, :polimero_id

  def before_save
    if self.serie != nil
      @nueva = Existencia.new({:cantidad => self.cantidad, :numfact => self.mov_header.factura, :lote => self.lote, :serie => self.serie, :polimero => self.polimero, :bodega => self.bodega})
      @nueva.save
    elsif self.lote != nil
      @nea = Existencia.find(:first, :conditions => ["lote = (?)", self.lote])
      unless @nea == []
        @neacant = @nea.cantidad
        @nea.cantidad == @neacant + self.cantidad.to_i
        @nea.save
      end
    elsif Existencia.finpol(self.polimero_id,self.bodega_id) != nil
    	if self.bodega != nil
				@nea = Existencia.finpol(self.polimero_id,self.bodega_id).first
				unless @nea == []
					@neacant = @nea.cantidad
					@nea.cantidad == @neacant + self.cantidad.to_i
					@nea.save
				end
			end
    end
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
