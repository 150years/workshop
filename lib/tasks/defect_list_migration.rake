# frozen_string_literal: true

namespace :defect_list do
  desc 'Split attached photos into separate DefectListItems with photo_before'
  task split_photos_to_individual_items: :environment do
    count = 0

    DefectListItem.find_each do |item|
      next unless item.respond_to?(:photos) && item.photos.attached?

      photos = item.photos.to_a
      next if photos.empty?

      # Первый переносим в основной item
      if item.photo_before.blank?
        item.photo_before.attach(photos.first.blob)
        puts "Attached first photo to existing item ##{item.id}"
        count += 1
      end

      # Остальные создаём в новых копиях
      photos.drop(1).each do |photo|
        new_item = item.dup
        new_item.save!
        new_item.photo_before.attach(photo.blob)
        puts "Created new item ##{new_item.id} with photo for #{item.defect_list.order.name}"
        count += 1
      end

      # Удаляем старые photos
      item.photos.purge
    end

    puts "Migration completed: #{count} photos processed"
  end
end
