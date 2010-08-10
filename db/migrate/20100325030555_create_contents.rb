class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.string  :title,       :null => false
      t.string  :uploader_id, :null => false
      t.string  :author_id
      t.integer :album_id
      t.integer :content_type
      t.string  :description
      t.string  :type, :null => false

      t.string   :source_file_name
      t.string   :source_content_type
      t.integer  :source_file_size
      t.datetime :source_updated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
