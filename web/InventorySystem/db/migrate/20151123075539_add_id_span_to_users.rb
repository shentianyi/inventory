class AddIdSpanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :id_span, :string
  end
end
