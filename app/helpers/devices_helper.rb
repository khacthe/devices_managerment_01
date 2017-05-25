module DevicesHelper

  def get_borrowed borrowed
    if borrowed
      t "device.borrowed"
    else
      t "device.not_yet_borrowed"
    end
  end

  def get_index index
    index += Settings.view.increase_index
  end

  def verify_admin user
    user.position == User.user_positions[:admin] ? true : false
  end

end
