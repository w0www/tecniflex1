class RecibArchMailer < ActionMailer::Base
  
  def enviado(cliente,trabajo)
  	@cliente = cliente
    subject   'Envio de Visto Bueno'
    recipients ['patricio.arluciaga@gmail.com', 'jaime.kunze@tecniflex.cl']
    from      'preprensa@tecniflex.cl'
    body      :cliente => cliente, :trabajo => trabajo
  end

	def enviapdf(ord_trab,email)
		@ord_trab = ord_trab
		subject 		'Orden de Trabajo Tecniflex'
		recipients 	['patricio.arluciaga@gmail.com']
		from				'preprensa@tecniflex.cl'
		content_type 'multipart/alternative'
		attachment "application/pdf" do |a|
			a.body = email
		end
		body				:ot => @ord_trab.nomprod
	end
	
end
