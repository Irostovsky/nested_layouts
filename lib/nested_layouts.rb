module ActionView #:nodoc:
  module Helpers #:nodoc:
    # Allows you to wrap part of the template into layout
    # thus allowing to produce nested layouts.
    #
    # == Wrapping layout into another layout
    #
    # Let's assume you have controller which action 'hello' just was called.
    # Controller was set up to use 'inner' layout:
    #
    # app/controllers/hello_controller.rb
    #
    #   class HelloController < ApplicationController
    #     layout 'inner'
    #
    #     def hello
    #       render :text => 'Hello, world!'
    #     end
    #   end
    #
    # app/views/layouts/inner.rhtml
    #
    #   <% inside_layout 'outer' do -%>
    #     <div class="hello">
    #       <h1>Greetings</h1>
    #       <%= yield %>
    #     </div>
    #   <% end -%>
    #
    # app/views/layouts/outer.rhtml
    #
    #   <html>
    #   <body>
    #     <div class="content">
    #       <%= yield %>
    #     </div>
    #   </body>
    #   </html>
    #
    # Result will look like this (formatted for better reading):
    #
    #   <html>
    #   <body>
    #     <div class="content">
    #       <div class="hello">
    #         <h1>Greetings</h1>
    #         Hello, world!
    #       </div>
    #     </div>
    #   </body>
    #   </html>
    #
    # == Concept
    #
    # Concept of layout nesting here is based on the assumption that every
    # inner layout is used only to _customize_ it's outer layout and thus every
    # inner layout is used only with one specific outer layout. With this in
    # mind we can conclude that every layout must know it's outer layout and
    # thus information about outer layout must be embeded directly into inner
    # layout. Controller doesn't need to know about the whole stack of layouts,
    # so you should just specify the most inner layout in it.
    #
    # == Passing data
    #
    # You can pass data from inner layout to outer one, e.g.:
    #
    # layouts/inner.rhtml
    #
    #   <% content_for 'menu' do -%>
    #     <ul>
    #       <li><a href="about_us">About Us</a></li>
    #       <li><a href="products">Products</a></li>
    #     </ul>
    #   <% end -%>
    #
    #   <% inside_layout 'outer' do -%>
    #     <% @other_data_for_outer_layout = 'foo' -%>
    #     <%= yield %>
    #   <% end -%>
    #
    # layouts/outer.rhtml
    #
    #   <%= yield 'menu' %>
    #   <br/>
    #   The data was: <%= @other_data_for_outer_layout %>
    #   <br/>
    #   <%= yield %>
    #
    module NestedLayoutsHelper
      # Wrap part of the template into layout.
      #
      # If layout doesn't contain '/' then corresponding layout template
      # is searched in default folder ('app/views/layouts'), otherwise
      # it is searched relative to controller's template root directory
      # ('app/views/' by default).
      def inside_layout(layout, &block)
		    layout = layout.include?('/') ? layout : "layouts/#{layout}"
		    concat(@template.render_file(layout, true, '@content_for_layout' => capture(&block)), block.binding)
			end
		end
	end
end
