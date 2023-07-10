# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#save' do
    subject { user.save }

    let(:user) { described_class.new email:, access_token: }
    let(:email) { Faker::Internet.email }
    let(:access_token) { Faker::Alphanumeric.alphanumeric }

    context 'パラメータが正当であるとき' do
      it { is_expected.to be_truthy }
    end

    context 'email' do
      context 'フォーマットが正しくないとき' do
        let(:email) { 'foo.com' }

        it { is_expected.to be_falsey }
      end

      context '同じメールアドレスを持つユーザが存在するとき' do
        before do
          described_class.create! email:, access_token: Faker::Alphanumeric.alphanumeric
        end

        it { is_expected.to be_falsey }
      end
    end

    context 'sessionid' do
      context '値が設定されていないとき' do
        it { is_expected.to be_truthy }

        it 'セッションIDが自動的に設定される' do
          expect { subject }.to change(user, :sessionid).from(nil).to String
        end
      end

      context '同じセッションIDを持つユーザが存在するとき' do
        let(:user) { described_class.new email:, sessionid:, access_token: }
        let(:sessionid) { Faker::Alphanumeric.alphanumeric }

        before do
          described_class.create! email: Faker::Internet.email,
                                  sessionid:, access_token: Faker::Alphanumeric.alphanumeric
        end

        it { is_expected.to be_falsey }
      end
    end

    context 'access_token' do
      context '値が設定されていないとき' do
        let(:access_token) { nil }

        it { is_expected.to be_falsey }
      end

      context '同じアクセストークンを持つユーザが存在するとき' do
        before do
          described_class.create! email: Faker::Internet.email, access_token:
        end

        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#find_by' do
    context 'email' do
      subject { described_class.find_by! email: email.upcase }

      let(:email) { Faker::Internet.email }
      let(:access_token) { Faker::Alphanumeric.alphanumeric }

      before do
        described_class.create! email:, access_token:
      end

      context '大文字小文字違いのメールアドレスで検索するとき' do
        it '同一のレコードを発見する' do
          expect(subject).to eq described_class.find_by! email: email.downcase
        end
      end
    end
  end
end
