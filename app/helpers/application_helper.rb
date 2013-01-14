module ApplicationHelper

	def logo
		image_tag("logo.png", :alt => "Sample App", :class => "round")
	end

	def title 
		standart_title = "RoR Samole"
		if @title.nil?
			standart_title
		else
			"#{standart_title} | #{@title}"
		end
	end
end
