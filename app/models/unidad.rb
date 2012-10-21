class Unidad < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    nombre      :string, :name => true
    descripcion :text
    cantunimenor	:integer
    timestamps
  end

  has_many :existencias
  belongs_to :unimenor, :class_name => "Unidad", :foreign_key => "unimenor_id"
  has_many :unimayor, :class_name => "Unidad", :foreign_key => "unimayor_id"

  default_scope :order => 'nombre'
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
