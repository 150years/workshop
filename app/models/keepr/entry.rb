# frozen_string_literal: true

# app/models/keepr/entry.rb
module Keepr
  class Entry < ApplicationRecord
    belongs_to :project, optional: true
    belongs_to :order_version, optional: true
  end
end
