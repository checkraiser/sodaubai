class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  attr_accessible :username, :code
  devise :cas_authenticatable
  belongs_to :imageable, :polymorphic => true
  after_create :set_roles


  def cas_extra_attributes=(extra_attributes)
    if extra_attributes["status"] == 0
    	self.add_role :guest unless self.has_role?(:guest)
    else    	    		 
        self.remove_role :guest if self.has_role?(:guest)       
    		self.code = extra_attributes["masinhvien"]
        svs = SinhVien.where(:ma_sinh_vien => self.code)
        sv = svs.first unless svs.empty?
        gvs = GiangVien.where(:ma_giang_vien => self.code)
        gv = gvs.first unless gvs
        self.imageable = sv if sv
        self.imageable = gv if gv
    end
  end
  
  protected
  def set_roles
    unless self.has_role?(:guest)
      self.add_role :normal 
      if self.imageable then 
        if self.imageable.is_a?(GiangVien) then 
          self.imageable.lop_mon_hocs.each do |lop|
            self.add_role(:giangvien, lop)
          end
        elsif self.imageable.is_a?(SinhVien) then 
          self.imageable.lop_mon_hocs.each do |lop|
            self.add_role(:sinhvien, lop)
          end
        end
      end
    end
  end
end
