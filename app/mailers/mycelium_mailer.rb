class MyceliumMailer < ApplicationMailer
  include MyceliumMailerHelper

  def qr_code_email(mycelia, user)
    @mycelia = mycelia
    generate_qr_codes(mycelia)

    attachments['qr_code.pdf'] = WickedPdf.new.pdf_from_string(
      render_to_string(template: 'mycelium_mailer/qr_code_email', formats: [:pdf])
    )
    mail(to: user.email, subject: 'QR Code Email') do |format|
      format.html { render layout: 'mailer' }
    end
    mycelia.each do |mycelium|
      svg_file_path = Rails.root.join('tmp', "#{mycelium.organization_id.to_s + '-' + mycelium.name}.svg")

      begin
        File.delete(svg_file_path)
      rescue => e
        Rails.logger.error("Error deleting SVG file: #{e.message}")
      end
    end
  end
  
  private

  def generate_qr_codes(mycelia)
    mycelia.each do |mycelium|
      qr = RQRCode::QRCode.new("#{ENV.fetch("CUSTOM_URL_SCHEME")}://mycelium/#{mycelium.id}") 
      svg_qr_code = qr.as_svg
      svg_file_path = Rails.root.join('tmp', "#{mycelium.organization_id.to_s + '-' + mycelium.name}.svg")

      begin
        File.open(svg_file_path, 'w') do |file|
          file.write(svg_qr_code)
        end
      rescue => e
        Rails.logger.error("Error writing SVG file: #{e.message}")
      end
    end
  end
end
