class CreateActivityLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :activity_logs do |t|
      t.string :project_name
      t.string :activity_name
      t.json :params
      t.json :activity_config

      t.timestamps
    end
  end
end
