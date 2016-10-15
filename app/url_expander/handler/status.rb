module UrlExpander
  module Handler
    class Status
      def self.handle(ctx)
        ctx.render 'OK'
      end
    end
  end
end
