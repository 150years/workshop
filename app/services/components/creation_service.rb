class Components::CreationService
  attr_reader :component, :original_component

  def initialize(current_company, params, component = nil)
    @current_company = current_company
    @params = params
    @component = component
    @original_component = nil
  end

  def build
    if @params[:template_id].present?
      @original_component = @current_company.components.find(@params[:template_id])
      @component = @original_component.dup
      @component.name = "#{@component.name} (Copy)"
      @component.image.attach(@original_component.image.blob) if @original_component.image.attached?
    else
      @component = Component.new(category: nil)
    end
    self
  end

  def save
    @component.company = @current_company

    attach_template_image

    @component.save
  end

  private

  def attach_template_image
    return unless @params[:image].blank? && @params[:template_id].present? && @params[:image_blob_id].present?

    @component.image.attach(ActiveStorage::Blob.find_signed(@params[:image_blob_id]))
  end
end
