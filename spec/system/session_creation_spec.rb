# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Session Creation', type: :system do
  context '未ログインであるとき' do
    subject do
      visit new_session_url

      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Log in'

      page
    end

    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password }

    context 'フォームへの入力が全て正当であるとき' do
      context 'APIサーバから成功レスポンスが返ってきたとき' do
        before do
          WebMock.stub_request(:post, File.join(Api::User.base_url, 'signin')).to_return(
            body:    {
              access_token: 'some_token',
              token_type:   'bearer'
            }.to_json,
            status:  200,
            headers: { 'Content-Type' => 'application/json' }
          )
          WebMock.stub_request(:get, File.join(Api::User.base_url, 'files')).to_return(
            body:    '{}',
            status:  200,
            headers: { 'Content-Type' => 'application/json' }
          )
        end

        it 'ファイル一覧表示用のURLにリダイレクトする' do
          expect(subject).to have_current_path files_path
        end

        it 'ログインに成功した旨を示すメッセージが表示される' do
          expect(subject).to have_content 'You logged in successfully'
        end
      end

      context 'APIサーバからエラーレスポンスが返ってきたとき' do
        before do
          WebMock.stub_request(:post, File.join(Api::User.base_url, 'signin')).to_return status: 500
        end

        it '500エラー用のページを表示する' do
          expect(subject).to have_content 'sorry'
        end
      end
    end

    context 'フォームへの入力に不正があるとき' do
      context '各フォームへの入力が空であるとき' do
        let(:email) { nil }
        let(:password) { nil }

        before do
          WebMock.stub_request(:post, File.join(Api::User.base_url, 'signin')).to_return(
            body:    {
              status: 400,
              title:  'Bad Request',
              error:  'invalid_request'
            }.to_json,
            status:  400,
            headers: { 'Content-Type' => 'application/problem+json' }
          )
        end

        it 'サインイン用のページを表示する' do
          subject

          expect(page).to have_field 'Email'
          expect(page).to have_field 'Password'
        end

        it '送信した値が正しくない旨が表示される' do
          expect(subject).to have_content 'email, password or both are invalid'
        end
      end
    end
  end

  context 'ログイン済みであるとき' do
    subject do
      visit new_session_url

      page
    end

    context 'セッションが無効であるとき' do
      before do
        WebMock.stub_request(:post, File.join(Api::User.base_url, 'signin')).to_return(
          body:    {
            access_token: 'some_token',
            token_type:   'bearer'
          }.to_json,
          status:  200,
          headers: { 'Content-Type' => 'application/json' }
        )
        WebMock.stub_request(:get, File.join(Api::User.base_url, 'files')).to_return(
          body:    {
            status: 401,
            title:  'Unauthorized',
            error:  'invalid_token'
          }.to_json,
          status:  401,
          headers: { 'Content-Type' => 'application/problem+json' }
        )

        visit new_session_url

        fill_in 'Email', with: Faker::Internet.email
        fill_in 'Password', with: Faker::Internet.password
        click_button 'Log in'
      end

      it 'ログイン用のURLにリダイレクトする' do
        expect(subject).to have_current_path new_session_url
      end
    end

    context 'セッションが有効であるとき' do
      before do
        WebMock.stub_request(:post, File.join(Api::User.base_url, 'signin')).to_return(
          body:    {
            access_token: 'some_token',
            token_type:   'bearer'
          }.to_json,
          status:  200,
          headers: { 'Content-Type' => 'application/json' }
        )
        WebMock.stub_request(:get, File.join(Api::User.base_url, 'files')).to_return(
          body:    '{}',
          status:  200,
          headers: { 'Content-Type' => 'application/json' }
        )

        visit new_session_url

        fill_in 'Email', with: Faker::Internet.email
        fill_in 'Password', with: Faker::Internet.password
        click_button 'Log in'
      end

      it 'ファイル一覧表示用のURLにリダイレクトする' do
        expect(subject).to have_current_path files_path
      end
    end
  end
end
