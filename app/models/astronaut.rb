class Astronaut < ApplicationRecord
  validates_presence_of :name, :age, :job

  has_many :astronaut_missions
  has_many :missions, through: :astronaut_missions

  # Class Methods
  
  def self.average_age
    average(:age)
  end

  # Instance Methods
  
  def mission_order_alpha
    missions.order(title: :asc)
  end

  def total_time
    missions.sum(:time_in_space)
  end
end
