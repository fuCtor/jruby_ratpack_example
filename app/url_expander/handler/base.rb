require 'active_support/core_ext/benchmark'

module UrlExpander
  module Handler
    java_import 'ratpack.exec.Promise'
    Base = Struct.new(:request, :params, :ctx) do
      def self.handle(ctx)
        if ctx.getRequest.getMethod.isPost
          ctx.getRequest.getBody.then do |data|
            proc_data ctx, data.getText
          end
        else
          proc_data ctx, ''
        end
      end

      def self.proc_data(ctx, data)
        params = ctx.getRequest.getQueryParams.to_h

        params['remote_ip'] = ctx.getRequest.getHeaders.get('X-Forwarded-For')

        self.new(data, params, ctx).execute.then do |result|
          ctx.getResponse.tap do |http_response|
            case result
              when Hash
                http_response.send('application/json;charset=UTF-8', JrJackson::Json.dump(result))
              else
                http_response.status(200).send
            end
          end
        end
      end

      def execute
      end
    end
  end
end
