class RecibArchMailer < ActionMailer::Base

  def enviado(cliente,trabajo)
  	@cliente = cliente
    subject   'Envio de Visto Bueno'
    recipients ['patricio.arluciaga@gmail.com', 'preprensa@tecniflex.cl']
    from      'preprensa@tecniflex.cl'
    body      :cliente => cliente, :trabajo => trabajo
  end

	def enviapdf(ord_trab,email)
		@ord_trab = ord_trab
		subject 		'Orden de Trabajo Tecniflex'
		recipients 	['patricio.arluciaga@gmail.com', 'preprensa@tecniflex.cl']
		from				'preprensa@tecniflex.cl'
		content_type 'multipart/mixed'
		part "text/plain" do |p|
			p.body = render_message("enviapdf_plain", :ot => @ord_trab.nomprod)
		end
		attachment "application/pdf" do |a|
			a.body = email
			a.filename = @ord_trab.nomprod
		end
	end

	def avisar_cliente(ord_trab,email)
		@ord_trab = ord_trab
		subject 		'Nueva Orden de Trabajo Tecniflex'
		recipients 	['patricio.arluciaga@gmail.com', 'preprensa@tecniflex.cl', email]
		from				'preprensa@tecniflex.cl'
		content_type 'multipart/mixed'
		part "text/plain" do |p|
			p.body = render_message("avisar_cliente_plain", :ot => @ord_trab.nomprod)
		end
		attachment "application/pdf" do |a|
			a.body = email
			a.filename = @ord_trab.nomprod
		end
	end

end
