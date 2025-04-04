# frozen_string_literal: true

class ComponentsController < ApplicationController
  before_action :set_component, only: %i[show edit update destroy]

  # GET /components
  def index
    components = current_company.components.with_image_variants.order(id: :desc)

    @search = components.ransack(params[:q])
    @pagy, @components = pagy(@search.result(distinct: true))
  end

  # GET /components/1
  def show; end

  # GET /components/new
  def new
    service = Components::CreationService.new(current_company, params).build
    @component = service.component
    @original_component = service.original_component
  end

  # GET /components/1/edit
  def edit; end

  # POST /components
  def create
    service = Components::CreationService.new(current_company, params, Component.new(component_params))

    if service.save
      redirect_to service.component, notice: 'Component was successfully created.'
    else
      @component = service.component
      @original_component = service.original_component
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /components/1
  def update
    if @component.update(component_params)
      redirect_to @component, notice: 'Component was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /components/1
  def destroy
    if @component.destroy
      redirect_to components_path, notice: 'Component was successfully destroyed.', status: :see_other
    else
      flash[:alert] = @component.errors.first.message
      redirect_to @component, status: :see_other
    end
  end

  def components_order_pdf
    @order = Order.find(params[:id])
    @version = @order.order_versions.final_or_latest

    category = params[:category]
    supplier_id = params[:supplier_id]

    if category.blank? || supplier_id.blank?
      render plain: 'Category or Supplier not provided', status: :bad_request and return
    end

    supplier = supplier_id == 'none' ? nil : Supplier.find_by(id: supplier_id)

    components_data = @version.products
                              .flat_map(&:product_components)
                              .select do |pc|
                                pc.component.category == category &&
                                  pc.component.supplier_id == supplier&.id
                              end

    if components_data.empty?
      render plain: "No components found for category #{category} and supplier #{supplier&.name || 'Unknown'}",
             status: :not_found and return
    end

    @components = components_data.group_by(&:component).transform_values { |pcs| pcs.sum(&:quantity) }

    pdf = render_to_string(
      pdf: "components_order_#{category}_supplier_#{supplier&.name || 'unknown'}",
      template: 'orders/components_order_pdf',
      formats: [:html],
      encoding: 'UTF-8'
    )

    send_data pdf,
              filename: "components_order_#{category}_#{supplier&.name&.parameterize || 'unknown'}.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  def prepare_components_order
    @order = Order.find(params[:id])
    @version = @order.order_versions.where(final_version: true).first # или .final если так помечается

    @components_summary = Hash.new(0)

    @version.products.includes(:components).find_each do |product|
      product.product_components.each do |pc|
        @components_summary[pc.component] += pc.quantity
      end
    end

    @grouped_by_type = @version.products
                               .includes(product_components: { component: :supplier })
                               .flat_map(&:product_components)
                               .group_by { |pc| pc.component.category }
                               .transform_values do |pcs|
      pcs.group_by(&:component).transform_values do |pcs_for_component|
        pcs_for_component.sum(&:quantity)
      end
    end
    @grouped_by_supplier = @components_summary.group_by { |component, _| component.supplier }
  end

  private

  def set_component
    @component = current_company.components.find(params.expect(:id))
  end

  def attach_template_image
    return unless component_params[:image].blank? && params[:template_id].present? && params[:image_blob_id].present?

    @component.image.attach(ActiveStorage::Blob.find_signed(params[:image_blob_id]))
  end

  def component_params
    params.expect(component: {}).permit(:code, :category, :name, :note, :color, :unit, :length, :width, :height,
                                        :thickness, :weight, :min_quantity, :price, :image, :supplier_id)
  end
end
