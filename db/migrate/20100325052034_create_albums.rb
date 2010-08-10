class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :title, :null => false
      t.string :description

      t.string   :cover_file_name
      t.string   :cover_content_type
      t.integer  :cover_file_size
      t.datetime :cover_updated_at
    end
  end

  def self.down
    drop_table :albums
  end
end
