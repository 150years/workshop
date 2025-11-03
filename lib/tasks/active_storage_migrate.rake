# frozen_string_literal: true

namespace :active_storage do
  desc 'Move blobs from local Disk to R2 (ENV: BATCH=50 DRY=1 START_ID=0)'
  task migrate_to_r2: :environment do
    target     = :r2
    batch_size = ENV.fetch('BATCH', 50).to_i
    dry_run    = ENV['DRY'].present?
    start_id   = ENV.fetch('START_ID', 0).to_i

    scope = ActiveStorage::Blob.where(id: start_id..)
                               .where.not(service_name: target.to_s)
                               .order(:id)

    puts "=== Migrating to #{target} | batch=#{batch_size} | dry=#{dry_run} | start_id=#{start_id}"
    puts "Found: #{scope.count}"

    scope.in_batches(of: batch_size) do |relation|
      relation.each do |b|
        path = b.service.send(:path_for, b.key)
        unless File.exist?(path)
          warn "!! missing file → blob##{b.id} #{b.filename}"
          next
        end

        if dry_run
          puts "DRY → blob##{b.id} #{b.filename} (#{b.byte_size} bytes)"
          next
        end

        b.service_name = target.to_s
        File.open(path, 'rb') { |io| b.upload(io) }
        b.update!(service_name: target.to_s)

        puts "OK → blob##{b.id} #{b.filename}"
      rescue StandardError => e
        warn "EE → blob##{b.id} #{b.filename}: #{e.class}: #{e.message}"
      end
    end

    puts '=== Done'
  end
end
