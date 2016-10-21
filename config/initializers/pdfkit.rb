PDFKit.configure do |config|
  config.wkhtmltopdf = '/usr/bin/wkhtmltopdf'
  config.default_options = {
    :page_size => 'Legal',
    :print_media_type => true
  }
  if Rails.env.production?
    config.root_url = "http://preprensa.tecniflex.cl"
  elsif Rails.env.preproduction?
    config.root_url = "http://test.tecniflex.cl"
  elsif Rails.env.development?
    config.root_url = "http://localhost:3000"
  end
end

