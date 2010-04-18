class ChangeMywikisTextToText < ActiveRecord::Migration
  def self.up
    change_column :mywikis, :text, :text
  end

  def self.down
    change_column :mywikis, :text, :string
  end
end
