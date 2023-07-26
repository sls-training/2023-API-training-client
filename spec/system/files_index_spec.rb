# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Files Index', type: :system do
  subject do
    visit files_url

    page
  end

  context '未ログインであるとき' do
    it 'ログインページにリダイレクトする' do
      expect(subject).to have_current_path new_session_url
    end
  end

  context 'ログイン済みであるとき' do
    let(:access_token) { Faker::Alphanumeric.alphanumeric }

    before do
      WebMock.stub_request(:post, File.join(Api::User.base_url, 'signin')).to_return(
        body:    {
          access_token:,
          token_type:   'bearer'
        }.to_json,
        status:  200,
        headers: { 'Content-Type' => 'application/json' }
      )
      WebMock.stub_request(:get, File.join(Api::User.base_url, 'files')).with(
        headers: {
          Authorization: "Bearer #{access_token}"
        }
      )

      visit new_session_url

      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: Faker::Internet.password

      click_button 'Log in'
    end

    context 'セッションが無効であるとき' do
      before do
        WebMock.stub_request(:get, File.join(Api::User.base_url, 'files'))
          .with(
            headers: {
              Authorization: "Bearer #{access_token}"
            }
          )
          .to_return(
            body:    {
              status: 401,
              title:  'Unauthorized',
              error:  'invalid_token'
            }.to_json,
            status:  401,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'ログインページにリダイレクトする' do
        expect(subject).to have_current_path new_session_url
      end
    end

    context 'セッションが有効であるとき' do
      context 'APIサーバから成功レスポンスが返ってきたとき' do
        let(:files) do
          [
            {
              id:          '76DA18B4-7CF0-48C1-A33D-2FFA0A4B345A',
              name:        'sample01.txt',
              description: 'My diary',
              size:        1024,
              created_at:  '2020-10-12T11:20:44+00:00',
              changed_at:  '2023-05-25T23:07:39+00:00'
            },
            {
              id:         '9BD3BEA3-67E7-401A-9A45-C6CAB38A052A',
              name:       'sample02.png',
              size:       1_048_576,
              created_at: '2020-10-12T11:10:30+00:00',
              changed_at: '2020-10-12T11:10:30+00:00'
            }
          ]
        end

        before do
          WebMock.stub_request(:get, File.join(Api::User.base_url, 'files'))
            .with(
              headers: {
                Authorization: "Bearer #{access_token}"
              }
            )
            .to_return(
              body:    { files: }.to_json,
              status:  200,
              headers: { 'Content-Type' => 'application/json' }
            )
        end

        it 'ファイル一覧が表示される' do
          subject

          expect(page).to have_content files[0][:name]
          expect(page).to have_content files[1][:name]
        end
      end

      context 'APIサーバからエラーレスポンスが返ってきたとき' do
        before do
          WebMock.stub_request(:get, File.join(Api::User.base_url, 'files'))
            .with(
              headers: {
                Authorization: "Bearer #{access_token}"
              }
            )
            .to_return(
              body:    '{}',
              status:  500,
              headers: { 'Content-Type' => 'application/json' }
            )
        end

        it '500用のページが表示される' do
          expect(subject).to have_content 'sorry'
        end
      end
    end
  end
end
