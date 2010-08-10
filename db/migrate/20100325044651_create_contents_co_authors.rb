class CreateContentsCoAuthors < ActiveRecord::Migration
  def self.up
    create_table :contents_co_authors do |t|
      t.integer :content_id,  :null => false
      t.integer :author_id,   :null => false
    end
  end

  def self.down
    drop_table :contents_co_authors
  end
end
