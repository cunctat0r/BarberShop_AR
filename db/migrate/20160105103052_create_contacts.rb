class CreateContacts < ActiveRecord::Migration
  def change
  	create_table :contacts do |t|
  		t.text :author
  		t.text :message
		
		t.timestamps
  	end  	
  end
end
