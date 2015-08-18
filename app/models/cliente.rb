  class Cliente < ActiveRecord::Base
  hobo_model # Don't put anything above this

  fields do
    name      :string, :required 
    razsocial :string
    sigla     :string, :required 
    rut       :string
    correo    :email_address
    direccion :string
    telefono  :string
    fpago     :string
    tarifa		:decimal, :precision => 8, :scale => 2, :default => 0
    plazopago :string
    descuento :string
    cuenta_usuario :boolean, :default => false
    password :string
    timestamps
  end
  
  has_many :impresoras
  has_many :contactos, :accessible => true
  has_many :ord_trabs
  has_many :curva_clientes
  has_many :curvas, :through => :curva_clientes, :accessible => true

  default_scope :order => 'name'


  def before_update
    # Comprobamos si el cliente tiene marcada la opcion de crear usuario
    # Si esta marcada creamos el usuario si no esta creado ya
    cliente = self
    logger.info "esto es self #{self}"
    usuario_cliente = User.find_by_email_address(self.correo) if self.correo
    if self.cuenta_usuario == true
      User.create(:name => self.name, :password => self.password, :email_address => self.correo, :state => "active", :iniciales => self.sigla, :tablero => false) if usuario_cliente.blank?
    # Si no esta marcada borramos el usuario si es que existe
    elsif self.cuenta_usuario == false && usuario_cliente
      usuario_cliente.delete
    end
  end

#<User id: nil, crypted_password: nil, salt: nil, remember_token: nil, remember_token_expires_at: nil, name: nil, email_address: nil, administrator: false, created_at: nil, updated_at: nil, state: "active", key_timestamp: nil, rol: nil, iniciales: nil, tablero: false>


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
