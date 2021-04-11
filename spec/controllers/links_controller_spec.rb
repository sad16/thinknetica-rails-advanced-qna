require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:link) { create(:link) }
  let(:user) { link.linkable.user }

  before { login(user) }

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: link.id }, format: :js }

    it 'should delete link' do
      expect { subject }.to change(Link, :count).by(-1)
    end

    context 'when the user is not the author' do
      let(:user) { create(:user) }

      it 'should not delete file' do
        expect { subject }.not_to change(Link, :count)
      end
    end
  end
end
