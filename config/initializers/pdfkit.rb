PDFKit.configure do |config|
	config.default_options = {
		:page_size => 'Letter',
		:print_media_type => true
	}
	config.root_url = "http://preprensa.tecniflex.cl"
end