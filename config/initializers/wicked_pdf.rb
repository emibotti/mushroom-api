WickedPdf.config = {
  exe_path: '/usr/local/bin/wkhtmltopdf',  # Set the path to the wkhtmltopdf binary. run which wkhtmltopdf to find this path.
  enable_local_file_access: true,
  dpi: 300,                          # DPI setting for higher resolution
  page_size: 'A4',                   # Page size (e.g., 'A4', 'Letter')
  template: 'mycelium_mailer/qr_code_email.pdf.erb',
  fonts: {
    custom: {
      normal: Rails.root.join('app', 'assets', 'fonts', 'Roboto-Regular.ttf').to_s
    }
  }
}
