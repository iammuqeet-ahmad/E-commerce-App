module LayoutHelper
  def flash_message
    flash_type = ''
    message = ''
    flash.map do |key, msg|
      message = msg
      case key
      when 'alert'
        flash_type = 'alert-danger'
      when 'notice'
        flash_type = 'alert-info'
      when 'error'
        flash_type = 'alert-warning'
      when 'success'
        flash_type = 'alert-success'
      end
    end
    content_dry(message, flash_type)
  end
  def content_dry(msg, str)
    hash = {}
    hash[:message] = msg
    custom_flash = 'alert fade show alert-dismissible ' << str
    hash[:flash_type] = custom_flash
    hash
  end
end