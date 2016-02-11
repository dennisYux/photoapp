class AddFieldsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :name, :string
    add_column :photos, :description, :string
    add_column :photos, :rating, :float
    add_column :photos, :image_url, :string
  end
end
