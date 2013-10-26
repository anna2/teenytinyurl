class AddReferenceToShortenedUrls < ActiveRecord::Migration
  def change
  	remove_column :shortened_urls, :user_id, :integer
  	add_reference :shortened_urls, :user, index: true
  end
end
