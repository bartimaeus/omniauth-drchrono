require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class DrChrono < OmniAuth::Strategies::OAuth2
      option :name, 'drchrono'

      option :client_options, {
        :site => 'https://drchrono.com/api',
        :authorize_url => 'https://drchrono.com/o/authorize',
        :token_url => 'https://drchrono.com/o/token/'
      }

      option :scope, 'user:read'

      uid do
        raw_info['id']
      end

      info do
        {
          'auth' => oauth2_access_token,
          'doctor' => doctor,
          'offices' => offices
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def callback_url
        full_host + script_name + callback_path
      end

      alias :oauth2_access_token :access_token

      def access_token
        ::OAuth2::AccessToken.new(client, oauth2_access_token.token, {
          :expires_in => oauth2_access_token.expires_in,
          :expires_at => oauth2_access_token.expires_at
        })
      end

      def raw_info
        @raw_info ||= access_token.get(profile_endpoint).parsed
      end

      def doctor
        @doctor ||= access_token.get(doctors_endpoint).parsed
      end

      def offices
        @offices ||= access_token.get(offices_endpoint).parsed['results']
      end

      private

      def profile_endpoint
        '/users/current'
      end

      def doctors_endpoint
        "/doctors/#{raw_info['doctor']}"
      end

      def offices_endpoint
        '/offices'
      end
    end
  end
end

OmniAuth.config.add_camelization 'drchrono', 'DrChrono'
