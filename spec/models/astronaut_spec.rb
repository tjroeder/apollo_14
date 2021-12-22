require 'rails_helper'

describe Astronaut, type: :model do
  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :age }
    it { should validate_presence_of :job }
  end

  describe 'Relationships' do
    it { should have_many :astronaut_missions }
    it { should have_many(:missions).through(:astronaut_missions) }
  end

  let!(:astronaut_1) { Astronaut.create!(name: "astro_1", age: 1, job: "job_1") }
  let!(:astronaut_2) { Astronaut.create!(name: "astro_2", age: 2, job: "job_2") }
  let!(:astronaut_3) { Astronaut.create!(name: "astro_3", age: 3, job: "job_3") }

  let!(:mission_1) { Mission.create!(title: "title_1", time_in_space: 1, astronauts: [astronaut_1, astronaut_2]) }
  let!(:mission_2) { Mission.create!(title: "title_2", time_in_space: 2, astronauts: [astronaut_1, astronaut_3]) }
  let!(:mission_3) { Mission.create!(title: "title_3", time_in_space: 3, astronauts: [astronaut_1]) }

  describe 'class methods' do
    describe '::average_age' do
      it 'returns the average age' do
        expect(Astronaut.average_age).to eq(2)
      end
    end
  end
  
  describe 'instance methods' do
    describe '#misson_order_alpha' do
      it 'returns missions in alphabetical order' do
        mission_3.update!(title: "a_title_3")
  
        expect(astronaut_1.mission_order_alpha).to eq([mission_3, mission_1, mission_2])
      end
    end

    describe '#total_time' do
      it 'returns the total time of all missions' do
        expect(astronaut_1.total_time).to eq(6)
      end
    end
  end
end
