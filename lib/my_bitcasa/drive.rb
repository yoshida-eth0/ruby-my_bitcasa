require 'my_bitcasa/folder'

module MyBitcasa
  class Drive < Folder
    [
      :mount_point,
      :deleted,
      :mirrored,
      :origin_device,
      :origin_device_id,
      :sync_type,
    ].each do |key|
      class_eval %{
        def #{key}
          @item["#{key}"]
        end
      }
    end
  end
end
