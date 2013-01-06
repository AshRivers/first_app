module ApplicationHelper
	def title 
		standart_title = "RoR Samole"
		if @title.nil?
			standart_title
		else
			"#{standart_title} | #{@title}"
		end
	end
end
