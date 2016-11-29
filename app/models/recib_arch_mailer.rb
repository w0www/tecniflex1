class RecibArchMailer < ActionMailer::Base

  def enviado(cliente,trabajo)
  	@cliente = cliente
    subject   'Envio de Visto Bueno'
    recipients ['patricio.arluciaga@gmail.com', 'preprensa@tecniflex.cl']
    from      'reposiciones@tecniflex.cl'
    body      :cliente => cliente, :trabajo => trabajo
  end

  # Metodo para enviar
	def enviapdf(ord_trab,email)
		@ord_trab = ord_trab
		subject 		'Orden de Trabajo Tecniflex'
    recipients 	['jaime.kunze@gmail.com', 'preprensa@tecniflex.cl']
    recipients << @ord_trab.cliente.correo
		from				'reposiciones@tecniflex.cl'
		content_type 'multipart/mixed'
		part "text/plain" do |p|
			p.body = render_message("enviapdf_plain", :ot => @ord_trab.nomprod)
		end
		attachment "application/pdf" do |a|
			a.body = email
			a.filename = "#{@ord_trab.numOT}.pdf"
		end
	end

  # Metodo para las reposiciones
	def avisar_cliente(ord_trab,pdf_cliente)
		@ord_trab = ord_trab
    emails = ['jaime.kunze@gmail.com', 'preprensa@tecniflex.cl']
    unless @ord_trab.cliente.contactos.blank?
      emails << @ord_trab.cliente.contactos.*.email
    else
      emails << @ord_trab.cliente.correo
    end
		subject 		'Nueva Orden de Trabajo Tecniflex'
		recipients 	emails
		from				'reposiciones@tecniflex.cl'
		content_type 'multipart/mixed'
		part "text/plain" do |p|
			p.body = render_message("avisar_cliente_plain", :ot => @ord_trab)
		end
		attachment "application/pdf" do |a|
			a.body = pdf_cliente
			a.filename = "#{@ord_trab.numOT}.pdf"
		end
	end

  # Metodo para avisar a preprensa
	def avisar_preprensa(ord_trab,pdf_preprensa)
		@ord_trab = ord_trab
    emails = ['jaime.kunze@gmail.com', 'preprensa@tecniflex.cl', 'imanol@alvarezperez.net']
		subject 		'Nueva Orden de Trabajo Tecniflex'
		recipients 	emails
		from				'preprensa@tecniflex.cl'
		content_type 'multipart/mixed'
		part "text/plain" do |p|
			p.body = render_message("avisar_preprensa_plain", :ot => @ord_trab)
		end
		attachment "application/pdf" do |a|
			a.body = pdf_preprensa
			a.filename = "#{@ord_trab.numOT}.pdf"
		end
	end
end
