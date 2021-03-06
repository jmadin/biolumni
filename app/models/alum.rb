class Alum < ActiveRecord::Base
  belongs_to :user
  has_many :degrees, :dependent => :destroy
  has_many :records, :dependent => :destroy
  has_many :photos, :dependent => :destroy

  validates :first_name, :presence => true
  validates :last_name, :presence => true, :uniqueness => {:scope => [:first_name, :middle_name], :message => "and first name combination already exists. If this is indeed correct, please add a middle name to distinguish between the two people."} 

  scope :order_degrees, -> { 
    joins(:degrees).order('graduation_year DESC') 
  }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |alum|
        csv << alum.attributes.values_at(*column_names)
      end
    end
  end

  acts_as_taggable

  searchable do
    text :mq_id  
    text :first_name  
    text :last_name  
    text :alum_notes  
    text :tag_list

    # join(:graduation_year, :target => Degree, :type => :string, :join => { :from => :alum_id, :to => :id })
    # string :graduation_year_sortable do 
    #   degree.graduation_year
    # end
  end

# graduation_year IS NOT NULL, graduation_year DESC

  # def self.search(search)
  #     if search
  #       where('mq_id LIKE ? OR first_name LIKE ? OR last_name LIKE ? OR alum_notes LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  #     else
  #       all
  #     end
  # end
  
end
