ActiveRecord::Schema.define(:version => 0) do
  create_table :poormans_crons, :force => true do |t|
    t.column :id,           :integer
    t.column :name,         :integer
    t.column :interval,     :integer
    t.column :performed_at, :datetime
  end
end
