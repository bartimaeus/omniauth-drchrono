require 'spec_helper'
require 'omniauth-drchrono-oauth2'

describe OmniAuth::Strategies::DrChrono do
  subject { OmniAuth::Strategies::DrChrono.new(nil) }

  it 'adds camelization for itself' do
    expect(OmniAuth::Utils.camelize('drchrono')).to eq('DrChrono')
  end

  describe '#client' do
    it 'has correct DrChrono site' do
      expect(subject.client.site).to eq('https://drchrono.com/api')
    end

    it 'has correct `authorize_url`' do
      expect(subject.client.options[:authorize_url]).to eq('https://drchrono.com/o/authorize')
    end

    it 'has correct `token_url`' do
      expect(subject.client.options[:token_url]).to eq('https://drchrono.com/o/token/')
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      expect(subject.callback_path).to eq('/auth/drchrono/callback')
    end
  end

  describe '#uid' do
    before :each do
      allow(subject).to receive(:raw_info) { Hash['id' => 'uid'] }
    end

    it 'returns the id from raw_info' do
      expect(subject.uid).to eq('uid')
    end
  end

  describe '#info / #raw_info' do
    let(:access_token) { instance_double OAuth2::AccessToken }

    let(:parsed_response) { Hash['doctor' => 14234, 'id' => 43456, 'is_doctor' => true, 'is_staff' => false, 'practice_group' => 8765544, 'username' => 'drchrono'] }

    let(:doctors_endpoint) { "doctors/14234" }
    let(:offices_endpoint) { 'offices' }
    let(:profile_endpoint) { 'users/current' }

    let(:doctors_response) { instance_double OAuth2::Response, parsed: parsed_response }
    let(:offices_response) { instance_double OAuth2::Response, parsed: parsed_response }
    let(:profile_response) { instance_double OAuth2::Response, parsed: parsed_response }

    before :each do
      allow(subject).to receive(:access_token).and_return access_token

      allow(access_token).to receive(:get)
        .with(doctors_endpoint)
        .and_return(doctors_response)

      allow(access_token).to receive(:get)
        .with(offices_endpoint)
        .and_return(offices_response)

      allow(access_token).to receive(:get)
        .with(profile_endpoint)
        .and_return(profile_response)
    end

    it 'returns parsed responses using access token' do
      expect(subject.info).to have_key 'auth'
      expect(subject.info).to have_key 'doctor'
      expect(subject.info).to have_key 'offices'

      expect(subject.raw_info['doctor']).to eq(14234)
      expect(subject.raw_info['id']).to eq(43456)
      expect(subject.raw_info['is_doctor']).to be_truthy
      expect(subject.raw_info['is_staff']).to be_falsey
      expect(subject.raw_info['practice_group']).to eq(8765544)
      expect(subject.raw_info['username']).to eq('drchrono')
    end
  end

  describe '#extra' do
    let(:raw_info) { Hash[:foo => 'bar'] }

    before :each do
      allow(subject).to receive(:raw_info).and_return raw_info
    end

    specify { expect(subject.extra['raw_info']).to eq raw_info }
  end

  describe '#access_token' do
    let(:expires_in) { 3600 }
    let(:expires_at) { 946688400 }
    let(:token) { 'token' }
    let(:access_token) do
      instance_double OAuth2::AccessToken, :expires_in => expires_in,
        :expires_at => expires_at, :token => token
    end

    before :each do
      allow(subject).to receive(:oauth2_access_token).and_return access_token
    end

    specify { expect(subject.access_token.expires_in).to eq expires_in }
    specify { expect(subject.access_token.expires_at).to eq expires_at }
  end

  describe '#authorize_params' do
    describe 'scope' do
      before :each do
        allow(subject).to receive(:session).and_return({})
      end

      it 'sets default scope' do
        expect(subject.authorize_params['scope']).to eq('settings:read user:read')
      end
    end
  end
end
