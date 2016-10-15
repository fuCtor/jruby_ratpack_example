require 'java'

java_import 'ratpack.server.RatpackServer'
java_import 'ratpack.registry.Registry'
java_import 'ratpack.exec.Blocking'

java_import 'ratpack.stream.Streams'
java_import 'ratpack.http.ResponseChunks'
java_import 'ratpack.server.ServerConfig'
java_import 'java.time.Duration'
java_import 'java.nio.charset.Charset'
java_import 'java.net.InetAddress'

java_import 'ratpack.server.BaseDir'
java_import 'ratpack.guice.Guice'
java_import 'ratpack.dropwizard.metrics.DropwizardMetricsConfig'
java_import 'ratpack.dropwizard.metrics.DropwizardMetricsModule'

module UrlExpander
  Server = Struct.new(:host, :port) do
    def self.run
      new('0.0.0.0', ENV['PORT'] || 3000).tap(&:run)
    end

    def run
      @server  = RatpackServer.of do |s|
        s.serverConfig(config)

        s.registry(Guice.registry { |g|
                     g.module(DropwizardMetricsModule.new)
                   })

        s.handlers do |c|
          c.get 'status',  Handler::Status
          c.path 'expand', Handler::Expander
          c.all            Handler::Default
        end
      end
      @server.start
    end

    def shutdown
      @server.stop
    end

    private

    def config
      ServerConfig.embedded
                  .port(port.to_i)
                  .address(InetAddress.getByName(host))
                  .development(ENV['RACK_ENV'] == 'development')
                  .base_dir(BaseDir.find)
                  .props("application.properties")
                  .require("/metrics", DropwizardMetricsConfig.java_class)
    end
  end
end
