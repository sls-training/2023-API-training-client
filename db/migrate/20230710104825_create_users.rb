class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.citext :email, null: false, index: { unique: true }
      t.string :sessionid, null: false, index: { unique: true }
      t.string :access_token, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
