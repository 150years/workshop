ActiveStorage::Blob.where.not(service_name: 'r2').find_each do |b|
  path = b.service.send(:path_for, b.key)
  raise "missing file #{b.key}" unless File.exist?(path)

  b.service_name = 'r2'
  b.upload(File.open(path, 'rb'))
  b.update_column(:service_name, 'r2')
  puts "OK → ##{b.id} #{b.filename}"
rescue StandardError => e
  warn "SKIP → ##{b.id} #{b.filename}: #{e.message}"
end
