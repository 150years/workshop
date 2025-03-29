# frozen_string_literal: true

# app/controllers/entries_controller.rb
class EntriesController < ApplicationController
  def index
    @entries = if params[:order_id].present?
                 Entry.includes(postings: :account).where(order_id: params[:order_id]).order(created_at: :desc)
               else
                 Entry.includes(postings: :account).order(created_at: :desc).limit(50)
               end
  end

  def new
    @entry = Entry.new
  end

  def create
    case params[:action_type]
    when 'client_payment'
      create_client_payment
    when 'purchase_materials'
      create_purchase_materials
    when 'agent_commission'
      create_agent_commission
    else
      render :index
    end
  end

  def new_payment
    @orders = Order.all
  end

  def create_payment
    order = Order.find(params[:order_id])
    amount = params[:amount].to_f

    Entry.create!(
      subject: "Client Payment for Order ##{order.id}",
      date: Time.zone.today,
      order_id: order.id,
      postings_attributes: [
        { account: Account.find_by(name: 'Cash'), amount: amount, side: 'debit' },
        { account: Account.find_by(name: 'Accounts Receivable'), amount: amount, side: 'credit' }
      ]
    )

    redirect_to accounts_path, notice: 'Payment recorded!'
  end

  private

  def create_client_payment
    @entry = Entry.create!(
      subject: 'Payment from Client',
      date: Time.current,
      order: Order.find(params[:order_id]),
      postings_attributes: [
        { account: Account.find_by(name: 'Cash'), side: 'debit', amount: params[:amount].to_f },
        { account: Account.find_by(name: 'Accounts Receivable'), side: 'credit', amount: params[:amount].to_f }
      ]
    )

    render turbo_stream: turbo_stream.append('entries', partial: 'entries/entry', locals: { entry: @entry })
  end

  def create_purchase_materials
    @entry = Entry.create!(
      subject: 'Material Purchase',
      date: Time.current,
      postings_attributes: [
        { account: Account.find_by(name: 'Materials - Aluminum'), side: 'debit', amount: params[:amount].to_f },
        { account: Account.find_by(name: 'Accounts Payable'), side: 'credit', amount: params[:amount].to_f }
      ]
    )

    render turbo_stream: turbo_stream.append('entries', partial: 'entries/entry', locals: { entry: @entry })
  end

  def create_agent_commission
    @entry = Entry.create!(
      subject: 'Agent Commission',
      date: Time.current,
      postings_attributes: [
        { account: Account.find_by(name: 'Agent Commissions'), side: 'debit', amount: params[:amount].to_f },
        { account: Account.find_by(name: 'Cash'), side: 'credit', amount: params[:amount].to_f }
      ]
    )

    render turbo_stream: turbo_stream.append('entries', partial: 'entries/entry', locals: { entry: @entry })
  end
end
