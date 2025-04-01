# frozen_string_literal: true

class BalancesController < ApplicationController
  def index
    set_date_range

    scope = Transaction
            .where(date: @from..@to)
            .includes(:order, :client, :agent)
            .order(date: :desc, created_at: :desc)

    scope = scope.where(order_id: params[:order_id]) if params[:order_id].present?

    @pagy, @transactions = pagy(scope, items: 10)

    calculate_totals(scope)

    respond_to do |format|
      format.html
      format.pdf do
        pdf = generate_pdf(scope, @from, @to)
        send_data pdf.render,
                  filename: "balance_#{@from}_#{@to}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  private

  def set_date_range
    @from = params[:from].presence || 30.days.ago.to_date
    @to = params[:to].presence || Time.zone.today
  end

  def apply_filters(scope)
    scope = scope.where(type_id: params[:type_id]) if params[:type_id].present?
    scope = scope.where(house_id: params[:house_id]) if params[:house_id].present?
    scope
  end

  def calculate_totals(scope)
    filtered_scope = apply_filters(scope)
    @total_credit = filtered_scope.where('amount > 0').sum(:amount)
    @total_debit = filtered_scope.where('amount < 0').sum(:amount)
    @income = @total_credit
    @expense = @total_debit
    @balance = @income + @expense
  end

  # rubocop:disable Metrics/AbcSize
  def generate_pdf(transactions, from, to)
    transactions = transactions.sort_by { |t| [-t.date.to_time.to_i, -t.created_at.to_i] }

    Prawn::Document.new(page_size: 'A4', margin: 30) do |pdf|
      pdf.text 'Balance Report', size: 20, style: :bold, align: :center
      pdf.move_down 10
      pdf.text "From: #{from.to_date.strftime('%d.%m.%Y')} To: #{to.to_date.strftime('%d.%m.%Y')}",
               size: 10, align: :right
      pdf.move_down 20

      table_data = build_balance_table(transactions)

      pdf.table(table_data, header: true, row_colors: %w[F0F0F0 FFFFFF]) do
        row(0).font_style = :bold
        self.cell_style = { size: 9 }
        self.position = :center
        self.width = pdf.bounds.width
      end
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def build_balance_table(transactions)
    balance = 0
    headers = %w[Date Debit Credit Balance Type House Agent Client Comment]
    data = [headers]

    transactions.each do |t|
      balance += t.amount

      date        = t.date.strftime('%d.%m.%Y')
      debit       = t.amount.negative? ? format('%.2f', t.amount.abs) : ''
      credit      = t.amount.positive? ? format('%.2f', t.amount) : ''
      balance_str = format('%.2f', balance)
      type        = t.type_id.humanize
      house       = t.order&.name || '-'
      agent       = t.agent&.name || '-'
      client      = t.client&.name || '-'
      comment     = t.description || '-'

      row = [date, debit, credit, balance_str, type, house, agent, client, comment]
      data << row
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    data
  end
end
