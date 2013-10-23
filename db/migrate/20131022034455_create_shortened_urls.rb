class CreateShortenedUrls < ActiveRecord::Migration
  def self.up
  	create_table :shortened_urls do |t|
  		t.string :url
      t.integer :user_id
      t.timestamps
  	end
  	add_index :shortened_urls, :url
  end

  def self.down
  	drop_table :shortened_urls
  end
end
