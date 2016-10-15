require 'spec_helper'
java_import 'ratpack.test.embed.EmbeddedApp'
java_import 'ratpack.test.exec.ExecHarness'

describe UrlExpander::Handler::Expander do
  let(:url) { '' }

  let(:server) do
    EmbeddedApp.fromHandlers do |chain|
      chain.all(described_class)
    end
  end

  it { expect(described_class).to be_respond_to :handle }
  it { expect(described_class.new).to be_respond_to :execute }

  context 'empty request' do
    it do
      server.test do |client|
        response = JrJackson::Json.load client.getText
        expect(response).to be_blank
      end
    end
  end

  context 'with url' do
    let(:url) { 'http://bit.ly/1bh0k2I' }

    context 'get request' do
      it do
        server.test do |client|
          response = client.params do |builder|
            builder.put('url', url)
          end .getText
          response  = JrJackson::Json.load(response)
          expect(response).to be_present
          expect(response).to be_key url
          expect(response[url].last).to match /\/ya\.ru/
        end
      end
    end

    context 'post request' do
      let(:body) { JrJackson::Json.dump({"urls" => url}) }

      it do
        server.test do |client|
          text = client.request do |req|
            req.body do |req_body|
              req_body.text body
            end
            req.post
          end .getBody.getText
          response = JrJackson::Json.load(text)
          expect(response).to be_present
          expect(response).to be_key url
          expect(response[url].last).to match /\/ya\.ru/
        end
      end

      context 'multiple urls' do
        let(:url) { ['http://bit.ly/Kmg4IB', 'http://bit.ly/1bh0k2I'] }
        it do
          server.test do |client|
            text = client.request do |req|
              req.body do |req_body|
                req_body.text body
              end
              req.post
            end .getBody.getText
            response = JrJackson::Json.load(text)
            expect(response).to be_present
            expect(response.size).to eq 2
          end
        end
      end
    end
  end

end