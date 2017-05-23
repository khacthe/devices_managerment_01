class Device < ApplicationRecord

  mount_uploader :thumnail, ThumnailUploader

  after_initialize :set_defaults, unless: :persisted?

  has_many :borrow_items, dependent: :destroy

  belongs_to :category
  belongs_to :workspace

  validates_presence_of :thumnail
  validates :name, presence: true
  validates :informations, presence: true
  validates :workspace_id, presence: true
  validates :category_id, presence: true

  scope :get_all_devices, -> do
    Device.all.order(borrowed: :asc)
  end

  scope :get_devices_by_category, -> category_id do
    where(category_id: category_id)
  end

  scope :get_devices_by_ids, -> ids do
    where(id: ids)
  end

  scope :get_devices_by_workspace, -> workspace_id do
    where(workspace_id: workspace_id)
  end

  class << self
    def import file
      spreadsheet = open_spreadsheet file
      header = spreadsheet.row(1)
      if check_valid_header header
        arr_failed = []
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          device = find_or_initialize_by id: row["id"]
          device_attribute = row.to_hash
          device_attribute["thumnail"] = File.open(device_attribute["thumnail"])
          device.attributes = device_attribute
          if device.valid?
            device.update_attributes! device_attribute
          else
            arr_failed << i
          end
        end
        arr_failed
      end
    end

    def open_spreadsheet file
      case File.extname file.original_filename
      when ".csv" then Roo::Csv.new(file.path, file_warning: :ignore)
      when ".xls" then Roo::Excel.new(file.path, file_warning: :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, file_warning: :ignore)
      else raise t "device.unknown_file"
      end
    end

    def check_valid_header arr_attribute
      result = true
      arr_attribute.each do |key|
        unless Device.column_names.include?(key)
          result = false
        end
      end
      result
    end

    def to_csv
    attributes = %w{id name informations status workspace_id category_id}
      CSV.generate(headers: true) do |csv|
        csv << attributes
        all.each do |device|
          csv << device.attributes.values_at(*attributes)
        end
      end
    end
  end

  private
  def set_defaults
    self.borrowed ||= false
  end

end
