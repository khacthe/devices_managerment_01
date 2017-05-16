module SessionBorrow
  def init_session
    session[:item] ||= []
  end

  def get_size_items
    session[:item].present? ? session[:item].size : Settings.server.min_size
  end

  def get_list_borrowed
    session[:item].present? ? session[:item] : []
  end

  def get_list_ids
    ids = []
    session[:item].each do |device_id|
      ids << device_id
    end
    ids
  end

  def get_list_device_id
    get_list_borrowed.present? ? get_list_ids : []
  end

  def add_list_borrowed device_id
    session[:item] << device_id
  end

  def get_index_device_id list_borrowed, device_id
    list_borrowed.find_index {|ld| ld == device_id}
  end

  def get_list_devices
    ids = get_list_device_id
    if ids.present?
      @devices = Device.get_devices_by_ids ids
    end
  end

  def add_device_into_item device_id
    index_device_id = get_index_device_id get_list_borrowed, device_id
    if index_device_id.blank?
      add_list_borrowed device_id
    end
  end

  def delete_device index
    session[:item].delete_at index
  end

  def delete_device_in_item device_id
    result = true
    index_device_id = get_index_device_id get_list_borrowed, device_id
    if index_device_id.blank?
      result = false
    else
      delete_device index_device_id
    end
    result
  end
end
