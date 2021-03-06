#encoding: UTF-8
module QuanlyHelper
	def get_status2(s)
		case s
		when 3
			return "Đã duyệt"
		when 4
			return "Không duyệt"
		end
	end
	def format_date(d)
		return d.strftime("%H:%M ngày %d/%m/%Y")
	end
	def ca_trong(v, ca)
		lich = v.select {|p| p[:ca] == ca}.first
		return {:res => nil, :val => "<p><br/><br/><br/></p>"} unless lich
		return {:res => 1, :val => "<p style='text-align:center;'><span style='font-weight:bold;'>#{lich[:ten_giang_vien]}</span><br/>#{lich[:ten_mon_hoc]}<br/>#{lich[:ma_lop]}</p>"}
	end
	def check_nghiday(lop, lich)		
	    ngay_day = DateTime.strptime(lich['time'][0].gsub("T","-").gsub("Z",""), "%Y-%m-%d-%H:%M").change(:offset => Rational(7,24))
	    nd=Time.zone.parse(ngay_day.to_s)    
	    lop = LopMonHoc.find(lop)
	    li = lop.lich_trinh_giang_days.where(ngay_day: nd).first
	    return false unless li
	    return li.daduyet?
	end
	def check_lido(lop, lich)
		ngay_day = DateTime.strptime(lich['time'][0].gsub("T","-").gsub("Z",""), "%Y-%m-%d-%H:%M").change(:offset => Rational(7,24))
	    nd=Time.zone.parse(ngay_day.to_s)    
	    lop = LopMonHoc.find(lop)
	    li = lop.lich_trinh_giang_days.where(ngay_day: nd).first
	    return nil unless li
	    return li.note
	end
end
