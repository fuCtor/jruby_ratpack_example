module UrlExpander
  module Handler
    module Default
      def self.handle(ctx)
        ctx.getResponse.status(404).send
      end
    end
  end
end
