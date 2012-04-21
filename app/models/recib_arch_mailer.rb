class RecibArchMailer < ActionMailer::Base
  
  def enviado(cliente,trabajo)
  	@cliente = cliente
    subject   'Envio de Visto Bueno'
    recipients ['patricio.arluciaga@gmail.com', 'jaime.kunze@tecniflex.cl']
    from      'preprensa@tecniflex.cl'
    body      :cliente => cliente, :trabajo => trabajo
  end

end
