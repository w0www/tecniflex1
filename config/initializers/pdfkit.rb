PDFKit.configure do |config|
	config.default_options = {
		:page_size => 'Letter',
		:print_media_type => true
	}
	config.root_url = "http://0.0.0.0"
end