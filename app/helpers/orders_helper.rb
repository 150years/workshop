# frozen_string_literal: true

module OrdersHelper
  def status_icons
    {
      'quotation' => 'circle.svg',
      'measurement' => 'ruler.svg',
      'design' => 'swatch-book.svg',
      'payment' => 'credit-card.svg',
      'production' => 'hammer.svg',
      'installation' => 'wrench.svg',
      'completed' => 'circle-check-big.svg',
      'canceled' => 'circle-off.svg'
    }.freeze
  end
end
