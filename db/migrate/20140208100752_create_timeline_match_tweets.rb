class CreateTimelineMatchTweets < ActiveRecord::Migration
  def change
    create_table :timeline_match_tweets do |t|
      t.string :text
      t.string :user_account
      t.string :user_name
      t.string :user_id
      t.index  :user_id
      t.string :status_id
      t.index  :status_id

      t.timestamps
    end
  end
end
