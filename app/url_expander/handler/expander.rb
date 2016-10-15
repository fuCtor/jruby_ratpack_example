module UrlExpander
  module Handler
    class Expander < Base
      java_import 'ratpack.exec.util.ParallelBatch'
      java_import 'ratpack.http.client.HttpClient'

      def execute
        data = request.present? ? JrJackson::Json.load(request) : {}

        httpClient = ctx.get HttpClient.java_class

        urls = [*data['urls'], *data['url'], *params['url']].compact
        unless urls.present?
          return Promise.value({})
        end

        tasks = urls.map do |url|
          Promise.async do |down|
            uri = Java.java.net.URI.new(url)
            locations = [url]
            httpClient.get(uri) do |spec|
              spec.onRedirect do |resposne, action|
                locations << resposne.getHeaders.get('Location')
                action
              end
            end .then do |_resp|
              down.success(locations);
            end
          end
        end

        ParallelBatch.of(tasks).yieldAll.flatMap do |results|
          response = results.each_with_object({}) do |result, locations|
            result.value.try do |list|
              locations[list.first] = list[1..-1]
            end
          end

          Promise.value response
        end
      end
    end
  end
end
