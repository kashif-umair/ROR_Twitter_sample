class FixColumnName < ActiveRecord::Migration
  
  def change
 	rename_column :tweets, :uId, :user_id
  
  end
end
