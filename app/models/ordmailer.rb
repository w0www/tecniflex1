class Ordmailer < ActionMailer::Base

	def enviaot(cliente,orden)
		@orden = orden
  	@cliente = cliente
    subject   'Envio de Visto Bueno'
    recipients ['patricio.arluciaga@gmail.com', 'jaime.kunze@tecniflex.cl']
    from      'preprensa@tecniflex.cl'
    body      :cliente => cliente, :orden => orden
    attachment "application/pdf" do |a|
    	dire = "http://0.0.0.0:3000/ord_trabs/" + orden.to_s
    	a.body = PDFKit.new dire
    end

  end

end
