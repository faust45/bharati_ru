module NoficationSystem
 def log_error(exception) 
   super(exception)

   begin
#     mail = 
#     Mailer.create_exception_notification(
#       :current_user => current_user,
#       :exception    => exception, 
#       :backtrace    => clean_backtrace(exception), 
#       :session      => session.instance_variable_get("@data"), 
#       :params       => params, 
#       :request_env  => request.env)
#
#     Thread.new do
#       Mailer.deliver(mail)
#     end
   rescue => e
     logger.error(e)
   end
  end
end
