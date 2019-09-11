class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.string :song_url
      t.string :platform
      t.string :title

      t.timestamps
    end
  end
end
