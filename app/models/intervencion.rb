class Intervencion < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    inicio        :datetime
    termino       :datetime
    final         :boolean
    observaciones :text
    timestamps
  end

  belongs_to :tarea, :accessible => true
  belongs_to :user

	attr_accessor :vuelta

 #before_save :rellenar

  after_create :actitar

  after_update :appendobs # SEGUIR DESDE AQUI

#  after_save :checktar

  def find_interu(cuser)
    @cuser = cuser
    Intervencion.find(:all, :joins => :user, :conditions => ["name = ?", @cuser.name.to_s])
  end

  def estaot
    if self.tarea != nil
      if self.tarea.ord_trab != nil
        self.tarea.ord_trab.armacod
      else
        "Sin OT"
      end
    else 
      "Sin Proceso"
    end
  end
  
  def inteproc
    if self.tarea != nil
      if self.tarea.proceso != nil
        self.tarea.proceso.nombre
      else
        ""
      end
    else 
      ""
    end
  end
  
  # --- Permissions --- #

  def create_permitted?
    acting_user.signed_up?
  end

  def update_permitted?
    acting_user.signed_up?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

  private
    def rellenar
      self.inicio = Time.now
    end

    def actitar
				if self.tarea.state == "habilitada"
					self.tarea.lifecycle.iniciar!(acting_user)
					if self.tarea.ord_trab.state ==	"habilitada"
						self.tarea.ord_trab.lifecycle.iniciar!(User.first)
					end
				end
    end

    def appendobs
    		if self.tarea
    			otobs = self.tarea.ord_trab
    			locobs = self.observaciones
    			ahora = self.termino.strftime('%H:%M %d/%m/%y')
    			if otobs.observaciones.length == 0
    				nllocobs = self.user.iniciales + " " + ahora + ": " + locobs
    			else
    				nllocobs = "\n" + self.user.iniciales + " " + ahora + ": " + locobs
    			end
    			unless locobs.length == 0
						unless otobs.observaciones.include?(ahora)
							otobs.observaciones = otobs.observaciones << nllocobs
							otobs.save
						end
					end
    		end
    end


    def checktar
      @ter = 0
      if self.termino
        self.tarea.intervencions.each do |interv|
          if interv.termino
            @ter += 1
          end
        end
      end
      if self.tarea.intervencions.count.to_i == @ter
        self.tarea.lifecycle.terminar!(acting_user)
      end
    end
end
