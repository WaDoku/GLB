require 'spec_helper'

describe 'entries management' do
  let(:admin) { create(:admin) }
  let(:entry) { create(:entry) }

  describe 'entries authorization' do
    context 'authenticated user' do
      before do
        login_as_user(admin)
      end
      context 'visits the entries index with a valid entry' do
        before do
          create(:entry, uebersetzung: 'funky translation')
          visit entries_path
        end
        it 'gets the template title' do
          expect(page).to have_content('Das Große Lexikon des Buddhismus')
        end
        it "and sees the field 'uebersetzungsfeld' of the entry" do
          expect(page).to have_content('funky translation')
        end
      end
    end
    context 'non-logged in user' do
      context 'visits the entries index with a valid entry' do
        before do
          create(:entry, uebersetzung: 'funky translation')
          visit entries_path
        end
        it 'sees page title' do
          expect(page).to have_content('Das Große Lexikon des Buddhismus')
        end
        it 'does not see the transliation of entries' do
          expect(page).not_to have_content('funky translation')
        end
        it 'does not see links to export entries ' do
          expect(page).not_to have_link('Einträge')
        end
      end
    end
    context 'unpublished entries' do
      before do
        login_as_user(admin)
        unpublished_entry = create(:entry, freigeschaltet: false)
        visit entry_path(unpublished_entry)
      end
      it 'show the scans' do
        expect(page).to have_selector('#page0')
      end
    end
    context 'published entries' do
      before do
        published_entry = create(:entry, freigeschaltet: true)
        visit entry_path(published_entry)
      end
      it 'do not show the scans' do
        expect(page).not_to have_selector('#page0')
      end
    end
  end
end
