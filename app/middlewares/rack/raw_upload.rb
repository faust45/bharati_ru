module Rack
  class RawUpload

    def initialize(app, opts = {})
      @app = app
      @paths = Array(opts[:paths])
      @paths.map!{|path|
        prepare_regexp(path)
      }
    end

    def call(env)
      raw_file_post?(env) ? convert_and_pass_on(env) : @app.call(env)
    end

    def upload_path?(request_path)
      @paths.any? do |candidate|
        wildcard_path_match?(request_path, candidate)
      end
    end

    private
      def convert_and_pass_on(env)
        tempfile = Tempfile.new('raw-upload.')
        filename = env['HTTP_X_FILE_NAME']
        content_type = MIME::Types.type_for(filename).last.content_type

        tempfile.instance_eval do
          @tfilename = filename
          @tcontent_type = content_type

          def original_filename
            @tfilename
          end

          def content_type
            @tcontent_type
          end
        end
        
        tempfile << env['rack.input'].read
        tempfile.flush
        tempfile.rewind
        fake_file = {
          :filename => filename,
          :type => content_type,
          :tempfile => tempfile
        }
        env['rack.request.form_input'] = env['rack.input']
        env['rack.request.form_hash'] ||= {}
        env['rack.request.query_hash'] ||= {}
        env['rack.request.form_hash']['file'] = fake_file
        env['rack.request.query_hash']['file'] = fake_file
        if query_params = env['HTTP_X_QUERY_PARAMS']
          require 'json'
          params = JSON.parse(query_params)
          file_name = params['qqfile']
          env['rack.request.form_hash'].merge!(params)
          env['rack.request.query_hash'].merge!(params)
        end
        @app.call(env)
      end
  
      def raw_file_post?(env)
        upload_path?(env['PATH_INFO']) &&
          env['REQUEST_METHOD'] == 'POST' &&
          env['CONTENT_TYPE'] == 'application/octet-stream'
      end
  
      def literal_path_match?(request_path, candidate)
        candidate == request_path
      end
  
      def wildcard_path_match?(request_path, candidate)
        candidate =~ request_path
      end
  
      def prepare_regexp(path)
        regexp = '^' + path.gsub('.', '\.').gsub('*', '.*') + '$'
        Regexp.new(regexp)
      end
  end
end
