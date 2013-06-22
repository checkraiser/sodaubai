require 'spec_helper'
require "cancan/matchers"
# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe LopMonHocsController do

  # This should return the minimal set of attributes required to create a valid
  # LopMonHoc. As you add validations to LopMonHoc, be sure to
  # adjust the attributes here as well.
  
  
  context "Giang vien dang nhap" do
    login_gv
    it "giang vien dang nhap khong co quyen xem lop khac" do
      gv2 = create(:giang_vien, ma_giang_vien:"1234")
      lop = create(:lop_mon_hoc, giang_vien: gv2)
      us2 = create(:user, code: "1234", imageable: gv2)
      #us2.should_receive(:after_create)
      #lop.roles.map(&:name).should include("giangvien")
      #LopMonHoc.with_role(:giangvien, us2).should include(lop)
      #LopMonHoc.with_role(:giangvien, @user).should include(lop)f
      get :show, {:id => lop.id}
      #subject.current_user.username.should == "dungth@hpu.edu.vn"
      #subject.current_user.has_role?(:giangvien, lop).should be_false

      #us2.has_role?(:normal).should be_true
      response.should redirect_to(root_path)
    end
    it "giang vien co quyen xem lop minh" do  
      get :show, {:id => lop.id}

    end
  end
  

end
