# frozen_string_literal: true

class MaterialUsesController < ApplicationController
  def index
    @material = Material.find(params[:material_id])
    @uses = @material.material_uses.order(date: :desc)
  end

  def create
    @use = MaterialUse.new(material_use_params)
    material = @use.material

    # Проверка: материал найден
    redirect_to materials_path, alert: 'Material not found.' and return unless material

    # Проверка: количество больше 0
    if @use.amount.nil? || @use.amount <= 0
      redirect_to materials_path, alert: 'Amount must be greater than 0.' and return
    end

    # Проверка: хватает ли на складе
    if @use.amount > material.amount
      redirect_to materials_path, alert: "Not enough stock. Available: #{material.amount}" and return
    end

    # Сохраняем списание и вычитаем из остатков
    if @use.save
      material.update!(amount: material.amount - @use.amount)
      redirect_to materials_path, notice: 'Material used successfully.'
    else
      redirect_to materials_path, alert: 'Failed to use material.'
    end
  end

  private

  def material_use_params
    params.expect(material_use: %i[material_id date amount order_id])
  end
end
