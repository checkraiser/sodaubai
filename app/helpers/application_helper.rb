module ApplicationHelper
	def content_for_or_pjax(name, &block)
		request.headers['X-PJAX'] ? yield : content_for(name, &Proc.new)
	end
	def current_tuan
		Tuan.all.detect {|t| t.tu_ngay.localtime <= DateTime.now and t.den_ngay.localtime >= DateTime.now }
	end
	def dc(l,sv)
		(sv.so_tiet_vang || 0).to_f * 100 / (l.so_tiet_phan_bo || 1)
	end
end
