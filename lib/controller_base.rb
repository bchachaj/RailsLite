require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false

  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "double render" if @already_built_response
    @already_built_response = true
    # @req.path = url
    @res.redirect(url, status= 302)

  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "double render" if @already_built_response
    @already_built_response = true
    @res.write(content)
    res['Content-Type'] = content_type
    store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    hack = self.class.name.split("")
    hack.pop(10)
    # p self.class.name
    controller_name = "#{hack.join("").downcase}_controller"

    template = File.read("views/#{controller_name}/#{template_name}.html.erb")

    render_content(
     ERB.new(template).result(binding), "text/html"
     )
     store_session(@res)
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
