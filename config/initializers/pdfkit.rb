PDFKit.configure do |config|
  config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf.sh'
  config.default_options = {
    :page_size => 'Legal',
    :print_media_type => true
  }
	config.root_url = "http://preprensa.tecniflex.cl"
end

