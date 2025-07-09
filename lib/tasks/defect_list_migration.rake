# frozen_string_literal: true

namespace :defect_list do
  desc 'Split each attached photo into separate DefectListItem with photo_before'
  task split_photos_to_individual_items: :environment do
    count = 0

    DefectListItem.includes(:photos_attachment, :photos_blob).find_each do |item|
      next if item.photos.blank?

      puts "DL for project ##{item.defect_list.order.name}"

      item.photos.each do |old_photo|
        clone = item.dup
        clone.photo_before.attach(old_photo.blob)
        clone.save!
        count += 1
        puts "Cloned item ##{item.id} to ##{clone.id}"
      end

      item.destroy!
    end

    puts "Migration completed: #{count} photos processed"
  end
end
