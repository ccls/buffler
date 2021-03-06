module CommonLibFormHelper

	def self.included(base)
		base.send(:include, InstanceMethods)
		base.class_eval do
			alias_method_chain( :method_missing, :field_wrapping 
				) unless base.respond_to?(:method_missing_without_field_wrapping)
		end
	end

	module InstanceMethods

#		def submit_link_to(value=nil,options={})
#			#	submit_link_to will remove :value, which is intended for submit
#			#	so it MUST be executed first.  Unfortunately, my javascript
#			#	expects it to be AFTER the a tag.
#	#		s = submit(value,options.reverse_merge(
#	#				:id => "#{object_name}_submit_#{value.try(:downcase).try(:gsub,/\s+/,'_')}"
#	#			) ) << @template.submit_link_to(value,nil,options)
#			s1 = submit(value,options.reverse_merge(
#					:id => "#{object_name}_submit_#{value.try(:downcase).try(
#						:gsub,/\s+/,'_').try(
#						:gsub,/(&amp;|'|\/)/,'').try(
#						:gsub,/_+/,'_')}"
#				) ) 
#			s2 = @template.submit_link_to(value,nil,options)
#			s2 << s1
#		end 

		def hour_select(method,options={},html_options={})
#			@template.hour_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			@template.select(object_name, method,
				(1..12),
				{:include_blank => 'Hour'}.merge(options), html_options)
		end

		def minute_select(method,options={},html_options={})
#			@template.minute_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			minutes = (0..59).to_a.collect{|m|[sprintf("%02d",m),m]}
			@template.select(object_name, method,
				minutes,
				{:include_blank => 'Minute'}.merge(options), html_options)
		end

		def meridiem_select(method,options={},html_options={})
#			@template.meridiem_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			@template.select(object_name, method,
				['AM','PM'], 
				{:include_blank => 'Meridiem'}.merge(options), html_options)
		end

		def sex_select(method,options={},html_options={})
#			@template.sex_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			@template.select(object_name, method,
				[['-select-',''],['male','M'],['female','F'],["don't know",'DK']],
				options, html_options)
		end
		alias_method :gender_select, :sex_select

		def date_text_field(method, options = {})
#			@template.date_text_field(
#				@object_name, method, objectify_options(options))
			format = options.delete(:format) || '%m/%d/%Y'
			tmp_value = if options[:value].blank? #and !options[:object].nil?
#				object = options[:object]
				tmp = self.object.send("#{method}") ||
				      self.object.send("#{method}_before_type_cast")
			else
				options[:value]
			end
			begin
				options[:value] = tmp_value.to_date.try(:strftime,format)
			rescue NoMethodError, ArgumentError
				options[:value] = tmp_value
			end
			options.update(:class => [options[:class],'datepicker'].compact.join(' '))
			@template.text_field( object_name, method, options )
		end

		def method_missing_with_field_wrapping(symb,*args, &block)
			method_name = symb.to_s
			if method_name =~ /^wrapped_(.+)$/
				unwrapped_method_name = $1	#	check_box, select, ...
				method      = args[0]	#	attribute name
				content = @template.field_wrapper(method,:class => unwrapped_method_name) do
					s = if respond_to?(unwrapped_method_name)
						options    = args.detect{|i| i.is_a?(Hash) }
						label_text = options.delete(:label_text) unless options.nil?
						if unwrapped_method_name == 'check_box'
							send("#{unwrapped_method_name}",*args,&block) <<
							self.label( method, label_text )
						else
							self.label( method, label_text ) <<
							send("#{unwrapped_method_name}",*args,&block)
						end
					else
						send("_#{method_name}",*args,&block)
					end
					s << (( block_given? )? @template.capture(&block) : '')
				end
				#	ActionView::TemplateError (private method `block_called_from_erb?' 
				( @template.send(:block_called_from_erb?,block) ) ? 
					@template.concat(content) : content
			else
				method_missing_without_field_wrapping(symb,*args, &block)
			end
		end

	end	#	module InstanceMethods

end
ActionView::Helpers::FormBuilder.send(:include, 
	CommonLibFormHelper )
