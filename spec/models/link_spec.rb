require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should validate_url_of :url }

  it 'has a GIST_HOST constant' do
    expect(Link::GIST_HOST).not_to be_nil
  end

  describe 'gist link' do
    let(:link) { create(:link, url: "https://gist.github.com/sad16/#{gist_id}") }
    let(:gist_id) { '2f0fdb94eabdfff07781724a77067a1b' }

    describe '#gist_id' do
      subject { link.gist_id }

      it { is_expected.to eq(gist_id) }

      context 'when link is not gist' do
        let(:link) { create(:link) }

        it { is_expected.to be_nil }
      end
    end

    describe '#gist??' do
      it { expect(link).to be_gist }

      context 'when link is not gist' do
        let(:link) { create(:link) }

        it { expect(link).not_to be_gist }
      end
    end
  end
end
