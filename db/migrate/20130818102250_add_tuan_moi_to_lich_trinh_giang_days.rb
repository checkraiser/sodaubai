class AddTuanMoiToLichTrinhGiangDays < ActiveRecord::Migration
  def change
    add_column :lich_trinh_giang_days, :tuan_moi, :integer
  end
end
