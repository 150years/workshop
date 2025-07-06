# frozen_string_literal: true

class AddCommentThaiToInstallationReportItems < ActiveRecord::Migration[8.0]
  def change
    add_column :installation_report_items, :comment_thai, :text
  end
end
