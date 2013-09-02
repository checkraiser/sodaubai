class LopMonHocSinhVien < ActiveRecord::Base

  @nam_hoc = ""
  @hoc_ky = ""

  def self.nam_hoc
    @nam_hoc
  end
  def nam_hoc
    self.class.nam_hoc
  end
  def self.nam_hoc=(n)
    @nam_hoc = n
  end
  def self.hoc_ky
    @hoc_ky
  end
  def self.hoc_ky=(n)
    @hoc_ky = n
  end
  def hoc_ky
    self.class.hoc_ky
  end

  FACETS = [:ma_lop, :ten_mon_hoc, :giang_vien, :nam_hoc, :hoc_ky, :ngay_sinh]
  searchable do 
    text :ma_sinh_vien
    text :fullname do 
      ho + " " + ho_dem + " " + ten
    end

    boolean :tin_chi
    string :ma_lop_hanh_chinh
    string :ngay_sinh do 
      sinh_vien.ngay_sinh.strftime("%B %Y")
    end
    string :ma_lop do 
      lop_mon_hoc.ma_lop
    end
    string :ten_mon_hoc do 
      lop_mon_hoc.ten_mon_hoc
    end
    string :giang_vien do 
      lop_mon_hoc.ten_giang_vien
    end
    string :nam_hoc do 
      @nam_hoc
    end
    string :hoc_ky do 
      @hoc_ky
    end      
  end

  default_scope order('ten, ho_dem, ho')
  default_scope :conditions => 'status is null or status = false'
  

  attr_accessible :ma_lop, :ma_lop_ghep, :ma_sinh_vien, :ma_mon_hoc, :ma_lop_hanh_chinh, :ten_mon_hoc, :loai, :ho_dem, :ten, :ho, :lop_ghep, :tin_chi

  belongs_to :lop_mon_hoc
  
  belongs_to :sinh_vien, :foreign_key => 'ma_sinh_vien', :primary_key => 'ma_sinh_vien'
  
  
  has_many :lich_trinh_giang_days, :dependent => :nullify
  has_many :thong_bao_lop_hocs, :dependent => :nullify

  validates :ma_sinh_vien,  :presence => true  
  def convert_dcc(diem)
    case diem
    when 100
      4
    when 90..99
      3
    when 80..89
      2
    when 70..79
      1
    else
      0
    end
  end
  def convert_grade(diem)
    case diem
    when 9..10
      3
    when 7..8
      2
    when 5..6
      1    
    else
      0
    end  
  end
  def convert_kocothuchanh(diem)
    case diem 
    when 10
      6
    when 9
      5
    when 8
      4
    when 7
      3
    when 6
      2
    when 5
      1
    else
      0
    end
  end
  def hodemdaydu
    (ho || "") + " " + (ho_dem || "")
  end

  def diemqt
    (diemcc || 0) + diemtbkt + convert_grade((diem_thuc_hanh.round(0).to_i if diem_thuc_hanh) || 0)
  end
  def diemcc
    return convert_dcc(100-(so_tiet_vang * 100 / lop_mon_hoc.so_tiet)) if so_tiet_vang and lop_mon_hoc.so_tiet
    #return self.so_tiet_vang
    return 4 unless so_tiet_vang
  end
  def diemtbkt
    return convert_grade((diemtbkt1.round(0).to_i if diemtbkt1) || 0)  if lop_mon_hoc.get_thuc_hanh == true     
    return convert_kocothuchanh( (diemtbkt1.round(0).to_i if diemtbkt1) || 0 )  if lop_mon_hoc.get_thuc_hanh == false     
  end
  def diemtbkt1
    if lop_mon_hoc.so_lan_kt.nil? or lop_mon_hoc.so_lan_kt == 0 then return 0
    elsif lop_mon_hoc.so_lan_kt > 0 and lop_mon_hoc.so_lan_kt <=5
      sum = 0
      lop_mon_hoc.so_lan_kt.times do |t|
        sum = sum + (send("lan#{t+1}".to_sym) || 0)
      end
      #((lan1 || 0) + (lan2 || 0) + (lan3 || 0) + (lan4 || 0) + (lan5 || 0))/ (sl)
      return sum / lop_mon_hoc.so_lan_kt
    end
    return 0
  end
  def conflict?
  	tkbs = sinh_vien.get_tkbs
  	mtkbs = lop_mon_hoc.get_tkbs
  	res = false
  	tkbs.each do |tkb|
  		break if res == true 
  		mtkbs.each do |tk|
  			if tkb.schedule.conflicts_with?(tk.schedule) then
  				res = true
  				break 
  			end
  		end
  	end
  	return res  	
  end
  
end
