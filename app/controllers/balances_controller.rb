# frozen_string_literal: true

class BalancesController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def index
    @from = params[:from].presence || 30.days.ago.to_date
    @to = params[:to].presence || Time.zone.today

    scope = Transaction
            .where(date: @from..@to)
            .includes(:order, :client, :agent)
            .order(date: :asc)

    @pagy, @transactions = pagy(scope, items: 1000)
    @income = scope.where('amount > 0').sum(:amount)
    @expense = scope.where('amount < 0').sum(:amount)
    @balance = @income + @expense

    respond_to do |format|
      format.html
      format.pdf do
        pdf = generate_pdf(@transactions, @from, @to)
        send_data pdf.render,
                  filename: "balance_#{@from}_to_#{@to}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def set_filters
    @from = params[:from].presence || 30.days.ago.to_date
    @to = params[:to].presence || Time.zone.today
  end

  def filtered_scope
    Transaction
      .where(date: @from..@to)
      .includes(:order, :client, :agent)
      .order(date: :asc)
  end

  def calculate_totals(scope)
    @income = scope.where('amount > 0').sum(:amount)
    @expense = scope.where('amount < 0').sum(:amount)
    @balance = @income + @expense
  end

  def generate_pdf(transactions, from, to)
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
end

# rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
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

  data
end
# rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
