require 'spec_helper'

describe NetboxClientRuby do
  it 'is configurable' do
    NetboxClientRuby.configure do |config|
      config.netbox.auth.token = 'my_very_special_token'
      config.netbox.api_base_url = 'https://netbox.test/api/'
      config.netbox.pagination.default_limit = 42
      config.netbox.pagination.max_limit = 84
      config.faraday.adapter = :net_http_persistent
      config.faraday.logger = :detailed_logger
      config.faraday.request_options = { open_timeout: 3, timeout: 15 }
    end

    expect(NetboxClientRuby.config.netbox.auth.token)
      .to eq 'my_very_special_token'
    expect(NetboxClientRuby.config.netbox.api_base_url)
      .to eq 'https://netbox.test/api/'
    expect(NetboxClientRuby.config.netbox.pagination.default_limit)
      .to eq 42
    expect(NetboxClientRuby.config.netbox.pagination.max_limit)
      .to eq 84
    expect(NetboxClientRuby.config.faraday.adapter)
      .to be :net_http_persistent
    expect(NetboxClientRuby.config.faraday.logger)
      .to be :detailed_logger
    expect(NetboxClientRuby.config.faraday.request_options)
      .to eq(open_timeout: 3, timeout: 15)
  end

  {
    dcim: NetboxClientRuby::DCIM
  }.each do |method, klass|
    context "returns the initialized #{method} object" do
      it 'is of the correct type' do
        expect(NetboxClientRuby.public_send(method)).to be_a klass
      end

      it 'is the same instance at each call' do
        expect(NetboxClientRuby.public_send(method))
          .to be NetboxClientRuby.public_send(method)
      end
    end
  end
end