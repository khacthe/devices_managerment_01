module DevicesHelper

  def get_borrowed borrowed
    if borrowed
      t "device.borrowed"
    else
      t "device.not_yet_borrowed"
    end
  end

  def get_categories
    Category.all
  end

  def get_index index
    index += Settings.view.increase_index
  end

end
