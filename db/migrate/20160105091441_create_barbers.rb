class CreateBarbers < ActiveRecord::Migration
  def change
	create_table :barbers do |t|
		t.text :name
		
		t.timestamps
  	end

  	Barber.create :name => 'Luca Vialli'
  	Barber.create :name => 'Rudi Foeller'
  	Barber.create :name => 'Diego Maradona'
  	Barber.create :name => 'Ruud Gullit'
  end
end
