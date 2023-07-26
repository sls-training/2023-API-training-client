# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Files Index', type: :system do
  subject do
    visit files_url({ page: page_number }.compact)

    page
  end

  let(:page_number) { nil }

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
      WebMock.stub_request(:get, File.join(Api::User.base_url, 'files'))
        .with(
          headers: {
            Authorization: "Bearer #{access_token}"
          }
        )
        .to_return(
          body:    '{}',
          status:  500,
          headers: {
            'Content-Type' => 'application/json',
            'Page'         => '1',
            'Per'          => '20',
            'Total'        => '0'
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

        context '最初のページにいるとき' do
          let(:next_page_url) { 'http://example.com/files?page=2' }
          let(:last_page_url) { 'http://example.com/files?page=5' }

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
                headers: {
                  'Content-Type' => 'application/json',
                  'Link'         => "<#{next_page_url}>; rel=\"next\", <#{last_page_url}>; rel=\"last\"",
                  'Page'         => '1',
                  'Per'          => '20',
                  'Total'        => '100'
                }
              )
          end

          it '次のページへのリンクが表示される' do
            expect(subject).to have_link 'Next', href: next_page_url
          end

          it '最後のページへのリンクが表示される' do
            expect(subject).to have_link 'Last', href: last_page_url
          end

          it 'ページネーションの全体情報が表示される' do
            expect(subject).to have_content 'Displaying items 1 - 20 of 100 in total'
          end

          it 'ファイル一覧が表示される' do
            subject

            expect(page).to have_content files[0][:name]
            expect(page).to have_content files[1][:name]
          end
        end

        context '中間のページにいるとき' do
          let(:page_number) { 2 }
          let(:first_page_url) { 'http://example.com/files?page=1' }
          let(:last_page_url) { 'http://example.com/files?page=5' }
          let(:prev_page_url) { 'http://example.com/files?page=1' }
          let(:next_page_url) { 'http://example.com/files?page=3' }

          before do
            WebMock.stub_request(:get, File.join(Api::User.base_url, 'files'))
              .with(
                query:   {
                  page: page_number
                },
                headers: {
                  Authorization: "Bearer #{access_token}"
                }
              )
              .to_return(
                body:    { files: }.to_json,
                status:  200,
                headers: {
                  'Content-Type' => 'application/json',
                  # rubocop: disable Layout/LineLength
                  'Link'         => "<#{prev_page_url}>; rel=\"prev\", <#{next_page_url}>; rel=\"next\", <#{first_page_url}>; rel=\"first\", <#{last_page_url}>; rel=\"last\"",
                  # rubocop: enable Layout/LineLength
                  'Page'         => '2',
                  'Per'          => '20',
                  'Total'        => '100'
                }
              )
          end

          it '前のページへのリンクが表示される' do
            expect(subject).to have_link 'Prev', href: prev_page_url
          end

          it '次のページへのリンクが表示される' do
            expect(subject).to have_link 'Next', href: next_page_url
          end

          it '最初のページへのリンクが表示される' do
            expect(subject).to have_link 'First', href: first_page_url
          end

          it '最後のページへのリンクが表示される' do
            expect(subject).to have_link 'Last', href: last_page_url
          end

          it 'ページネーションの全体情報が表示される' do
            expect(subject).to have_content 'Displaying items 21 - 40 of 100 in total'
          end

          it 'ファイル一覧が表示される' do
            subject

            expect(page).to have_content files[0][:name]
            expect(page).to have_content files[1][:name]
          end
        end

        context '最後のページにいるとき' do
          let(:page_number) { 5 }
          let(:first_page_url) { 'http://example.com/files?page=1' }
          let(:prev_page_url) { 'http://example.com/files?page=1' }

          before do
            WebMock.stub_request(:get, File.join(Api::User.base_url, 'files'))
              .with(
                query:   {
                  page: page_number
                },
                headers: {
                  Authorization: "Bearer #{access_token}"
                }
              )
              .to_return(
                body:    { files: }.to_json,
                status:  200,
                headers: {
                  'Content-Type' => 'application/json',
                  'Link'         => "<#{prev_page_url}>; rel=\"prev\", <#{first_page_url}>; rel=\"first\"",
                  'Page'         => '5',
                  'Per'          => '20',
                  'Total'        => '99'
                }
              )
          end

          it '前のページへのリンクが表示される' do
            expect(subject).to have_link 'Prev', href: prev_page_url
          end

          it '最初のページへのリンクが表示される' do
            expect(subject).to have_link 'First', href: first_page_url
          end

          it 'ページネーションの全体情報が表示される' do
            expect(subject).to have_content 'Displaying items 81 - 99 of 99 in total'
          end

          it 'ファイル一覧が表示される' do
            subject

            expect(page).to have_content files[0][:name]
            expect(page).to have_content files[1][:name]
          end
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
              headers: {
                'Content-Type' => 'application/json',
                'Page'         => '1',
                'Per'          => '20',
                'Total'        => '0'
              }
            )
        end

        it '500用のページが表示される' do
          expect(subject).to have_content 'sorry'
        end
      end
    end
  end
end
