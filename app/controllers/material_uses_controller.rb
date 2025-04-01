# frozen_string_literal: true

class MaterialUsesController < ApplicationController
  def index
    @material = Material.find(params[:material_id])
    @uses = @material.material_uses.order(date: :desc)
  end

  def create
    @use = MaterialUse.new(material_use_params)

    return redirect_to materials_path, alert: 'Failed to use material.' unless @use.save

    material = @use.material
    new_amount = material.amount - @use.amount

    if new_amount.negative?
      @use.destroy
      return redirect_to materials_path, alert: 'Not enough stock.'
    end

    material.update!(amount: new_amount)
    redirect_to materials_path, notice: 'Material used successfully.'
  end

  private

  def material_use_params
    params.expect(material_use: %i[material_id date amount order_id])
  end
end
