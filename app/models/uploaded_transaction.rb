class UploadedTransaction < ApplicationRecord
  belongs_to :listing_agent, required: false, class_name: "Agent"
  belongs_to :selling_agent, required: false, class_name: "Agent"

  scope :single_family_homes, -> { where(property_type: "single_family_home") }
  scope :sold, -> { where(status: "sold") }

  def full_address
    "#{address}, #{city}, #{state} #{zip}"
  end
  
  def self.dedup
    columns = [:zip, :address, :selling_date]
    ids = UploadedTransaction.order('created_at ASC').select("#{columns.join(',')}, COUNT(*)").group(columns).having("COUNT(*) > 1").pluck(:id)
    UploadedTransaction.where(id: ids).destroy_all
  end
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      puts row
      UploadedTransaction.create! row.to_hash
    end
    UploadedTransaction.dedup
  end
  
  def self.to_csv
    attributes = UploadedTransaction.attribute_names - ["created_at", "updated_at", "id"]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
  
end