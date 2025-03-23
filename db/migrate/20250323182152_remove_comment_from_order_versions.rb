# frozen_string_literal: true

class RemoveCommentFromOrderVersions < ActiveRecord::Migration[8.0]
  def change
    remove_column :order_versions, :comment, :text
  end
end
