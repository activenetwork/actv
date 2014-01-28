require 'actv/address'
require 'actv/phone_number'

module ACTV
  class User < ACTV::Identity

    attr_reader :first_name, :last_name, :middle_name, :gender,
      :display_name, :date_of_birth, :email, :user_name, :created_date

    attr_accessor :access_token

    alias dob date_of_birth

    def advantage_member
      @is_member ||= begin
        client= ACTV::Client.new({ oauth_token: @access_token })
        client.is_advantage_member?
      end
    end
    alias is_advantage_member? advantage_member

    def avatar_url
      @avatar_url ||= begin
        client= ACTV::Client.new({ oauth_token: @access_token })
        client.avatar_url
      end
    end

    def address
      @address ||= ACTV::Address.new(@attrs[:address]) unless @attrs[:address].nil?
    end

    def phone_number
      @phone_number ||= ACTV::PhoneNumber.new(@attrs[:phone_number]) unless @attrs[:phone_number].nil?
    end

  end
end
