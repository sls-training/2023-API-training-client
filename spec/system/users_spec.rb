# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  context 'APIサーバ上のユーザアカウントの作成に成功したとき' do
    subject do
      visit signup_url

      fill_in 'Name', with: Faker::Name.name
      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password
      click_button 'Sign up'

      page
    end

    let(:password) { Faker::Internet.password }

    before do
      WebMock.stub_request(:post, File.join(Api::User.base_url, 'user'))
        .to_return(
          body:    '{}',
          status:  200,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'ログイン用のURLにリダイレクトする' do
      expect(subject).to have_current_path login_path
    end

    it 'ユーザの作成に成功した旨を示すメッセージが表示される' do
      expect(subject).to have_content 'Your user account was created successfully'
    end
  end

  describe 'リクエストのパラメータが不正であるとき' do
    subject do
      visit signup_url

      click_button 'Sign up'

      page
    end

    before do
      WebMock.stub_request(:post, File.join(Api::User.base_url, 'user'))
        .to_return(
          body:    {
            status: 422,
            title:  'Unprocessable Entity',
            errors: [
              { name: 'name', reason: "can't be blank" },
              { name: 'email', reason: 'is invalid' },
              { name: 'password', reason:  "can't be blank" }
            ]
          }.to_json,
          status:  422,
          headers: { 'Content-Type' => 'application/problem+json' }
        )
    end

    it 'サインアップ用のページを表示する' do
      subject

      expect(page).to have_field 'Name'
      expect(page).to have_field 'Email'
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
    end

    it 'パラメータに関するバリデーションエラーが表示される' do
      subject

      expect(page).to have_content "name can't be blank"
      expect(page).to have_content 'email is invalid'
      expect(page).to have_content "password can't be blank"
    end
  end

  describe 'パスワードがパスワードの確認と一致しないとき' do
    subject do
      visit signup_url

      fill_in 'Name', with: Faker::Name.name
      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: Faker::Internet.password
      fill_in 'Password confirmation', with: Faker::Internet.password
      click_button 'Sign up'

      page
    end

    before do
      WebMock.stub_request(:post, File.join(Api::User.base_url, 'user')).to_return status: 200
    end

    it 'サインアップ用のページを表示する' do
      subject

      expect(page).to have_field 'Name'
      expect(page).to have_field 'Email'
      expect(page).to have_field 'Password'
      expect(page).to have_field 'Password confirmation'
    end

    it 'パスワードがパスワードの確認と一致しない旨のバリデーションエラーが表示される' do
      subject

      expect(page).to have_content "password_confirmation doesn't match with password"
    end
  end

  context 'クラインアントエラー以外のエラーが発生したとき' do
    subject do
      visit signup_url

      click_button 'Sign up'

      page
    end

    before do
      WebMock.stub_request(:post, File.join(Api::User.base_url, 'user')).to_return status: 500
    end

    it '500エラー用のページを表示する' do
      expect(subject).to have_content 'sorry'
    end
  end
end
