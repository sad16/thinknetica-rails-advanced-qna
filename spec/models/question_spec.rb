require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:best_answer).class_name('Answer').dependent(:destroy).optional }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '.with_best_answer scope' do
    subject { described_class.with_best_answer }

    let!(:question) { create(:question) }
    let!(:question_with_best_answer) { create(:question, :with_best_answer) }

    it { is_expected.to eq([question_with_best_answer]) }
  end

  describe '#answers_without_best' do
    subject { question.answers_without_best }

    let(:question) { create(:question_with_answer_and_best_answer) }
    let(:answers) { question.answers.where.not(id: question.best_answer_id) }

    it 'should answers without best' do
      is_expected.to match_array(answers)
    end
  end
end
