# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  def invoice(order_version)
    @order_version = order_version
    @order = order_version.order
    @customer_name = @order.client.name
    @order_number = @order.id

    pdf = generate_order_invoice_pdf

    attachments["invoice-#{@order.id}.pdf"] = {
      mime_type: 'application/pdf',
      content: pdf.render
    }

    mail(
      to: @order.client.email,
      subject: "Invoice for Order ##{@order.id}"
    )
  end

  private

  def generate_order_invoice_pdf # rubocop:disable Metrics/AbcSize
    Prawn::Document.new(page_size: 'A4', margin: 30) do |pdf|
      pdf.text "Order #{@order.id}", size: 20, style: :bold, align: :center
      pdf.move_down 10
      pdf.text "Customer: #{@order.client.name}", size: 12
      pdf.text "Order Date: #{@order.created_at.strftime('%d.%m.%Y')}", size: 12
      pdf.move_down 20
      pdf.text 'Items:', size: 14, style: :bold
      pdf.move_down 10
      @order_version.products.each do |product|
        pdf.text "#{product.name} - #{product.price}", size: 12
      end
      pdf.move_down 20
      pdf.text "Total Amount: #{@order_version.total_amount}", size: 14, style: :bold
      pdf.move_down 10
      pdf.text 'Thank you for your business!', size: 12, align: :center
      pdf.move_down 20
      pdf.text "Generated on: #{Time.zone.now.strftime('%d.%m.%Y %H:%M')}", size: 10, align: :right
    end
  end
end
