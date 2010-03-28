class CreateMywikis < ActiveRecord::Migration
  def self.up
    create_table :mywikis do |t|
      t.column :assigned_to_id, :string
      t.column :text, :string
    end
  end

  def self.down
    drop_table :mywikis
  end
end
