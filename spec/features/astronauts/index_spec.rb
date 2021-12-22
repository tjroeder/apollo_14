require 'rails_helper'

RSpec.describe 'astronauts index', type: :feature do
  let!(:astronaut_1) { Astronaut.create!(name: "astro_1", age: 1, job: "job_1") }
  let!(:astronaut_2) { Astronaut.create!(name: "astro_2", age: 2, job: "job_2") }
  let!(:astronaut_3) { Astronaut.create!(name: "astro_3", age: 3, job: "job_3") }

  let!(:mission_1) { Mission.create!(title: "title_1", time_in_space: 1, astronauts: [astronaut_1, astronaut_2]) }
  let!(:mission_2) { Mission.create!(title: "title_2", time_in_space: 2, astronauts: [astronaut_1, astronaut_3]) }
  let!(:mission_3) { Mission.create!(title: "title_3", time_in_space: 3, astronauts: [astronaut_1]) }

  before(:each) { visit astronauts_path }

  describe 'display elements' do
    it 'shows a list of astronauts names' do
      expect(page).to have_content(astronaut_1.name)
      expect(page).to have_content(astronaut_2.name)
      expect(page).to have_content(astronaut_3.name)
    end

    it 'shows each astronaut has name, age and job' do
      within("#astronaut-#{astronaut_1.id}") do
        expect(page).to have_content(astronaut_1.name)
        expect(page).to have_content(astronaut_1.age)
        expect(page).to have_content(astronaut_1.job)
      end

      within("#astronaut-#{astronaut_2.id}") do
        expect(page).to have_content(astronaut_2.name)
        expect(page).to have_content(astronaut_2.age)
        expect(page).to have_content(astronaut_2.job)
      end
      
      within("#astronaut-#{astronaut_3.id}") do
        expect(page).to have_content(astronaut_3.name)
        expect(page).to have_content(astronaut_3.age)
        expect(page).to have_content(astronaut_3.job)
      end
    end

    it 'shows the average age of astronauts' do
      expected = (astronaut_1.age + astronaut_2.age + astronaut_3.age) /  3
      
      expect(page).to have_content("Average Age: #{expected}")
      expect(page).to have_no_content("Average Age: #{expected}.0")
    end
    
    it 'truncates average age of astronauts' do
      astronaut_4 = Astronaut.create!(name: "astro_4", age: 3, job: "job_4")
      visit astronauts_path
      expected = ((astronaut_1.age + astronaut_2.age + astronaut_3.age + astronaut_4.age) /  4).truncate

      expect(page).to have_content("Average Age: #{expected}")
    end

    it 'shows list of space missions for each astronaut' do
      within("#astronaut-#{astronaut_1.id}") do
        expect(page).to have_content(mission_1.title)
        expect(page).to have_content(mission_2.title)
        expect(page).to have_content(mission_3.title)
      end

      within("#astronaut-#{astronaut_2.id}") do
        expect(page).to have_content(mission_1.title)
      end
      
      within("#astronaut-#{astronaut_3.id}") do
        expect(page).to have_content(mission_2.title)
      end
    end
    
    it 'shows the space missions in alphabetical order' do
      mission_3.update!(title: "a_title_3")
      visit astronauts_path
      
      within("#astronaut-#{astronaut_1.id}") do
        expect(mission_3.title).to appear_before(mission_1.title)
        expect(mission_3.title).to appear_before(mission_2.title)
        expect(mission_1.title).to appear_before(mission_2.title)
      end
    end
    
    it 'shows the total time in space for each astronaut' do
      within("#astronaut-#{astronaut_1.id}") do
        expected = mission_1.time_in_space + mission_2.time_in_space + mission_3.time_in_space
        expect(page).to have_content("Total Time in Space: #{expected} days")
      end
  
      within("#astronaut-#{astronaut_2.id}") do
        expected = mission_1.time_in_space
        expect(page).to have_content("Total Time in Space: #{expected} days")
      end
      
      within("#astronaut-#{astronaut_3.id}") do
        expected = mission_2.time_in_space
        expect(page).to have_content("Total Time in Space: #{expected} days")
      end
    end
  end
end