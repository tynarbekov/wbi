class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :studend_id
      t.string :student_password
      t.text :studend_body
      t.timestamps
    end
  end
end
