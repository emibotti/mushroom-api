class MyceliumMailer < ApplicationMailer
  def qr_code_email(mycelia, user)
    @mycelia = mycelia
    generate_qr_codes(mycelia)

    attachments['qr_code.pdf'] = WickedPdf.new.pdf_from_string(
      render_to_string(template: 'mycelium_mailer/qr_code_email', formats: [:pdf])
    )
    mail(to: user.email, subject: 'QR Code Email') do |format|
      format.html { render layout: 'mailer' }
    end
    # File.delete(Rails.root.join('tmp', 'qr_code.svg'))
  end
  
  private

  def generate_qr_codes(mycelia)
    mycelia.each do |mycelium|
      qr = RQRCode::QRCode.new(mycelium_url(mycelium))
      svg_qr_code = qr.as_svg
      svg_file_path = Rails.root.join('tmp', "#{mycelium.name}.svg")

      File.open(svg_file_path, 'w') do |file|
        file.write(svg_qr_code)
      end
    end
  end
end
