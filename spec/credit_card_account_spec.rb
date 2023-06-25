# frozen_string_literal: true

require 'rspec'
require_relative '../credit_card_account'

RSpec.describe CreditCardAccount do
  subject(:credit_card_account) { described_class.new(**args) }

  let(:args) { { name:, card_number:, limit:} }
  let(:name) { 'Test Account' }
  let(:card_number) { '4111111111111111' }
  let(:limit) { 500 }

  it { is_expected.to have_attributes(name:, card_number:, limit:, balance: 0) }

  describe '#charge' do
    subject { credit_card_account.balance }

    before { credit_card_account.charge(amount:) }

    context 'when amount is nil' do
      let(:amount) { nil }

      it { is_expected.to eq(0) }
    end

    context 'when amount raises the balance over the limit' do
      let(:amount) { 501 }

      it { is_expected.to eq(0) }

      context 'when card is not valid' do
        let(:card_number) { '1234567890' }

        it { is_expected.to eq(0) }
      end
    end

    context 'when amount does not raise the balance over the limit' do
      let(:amount) { 499 }

      it { is_expected.to eq(499) }

      context 'when card is not valid' do
        let(:card_number) { '1234567890' }

        it { is_expected.to eq(0) }
      end
    end
  end

  describe '#credit' do
    subject { credit_card_account.balance }

    before { credit_card_account.credit(amount:) }

    let(:amount) { 501 }

    it { is_expected.to eq(-501) }

    context 'when card is not valid' do
      let(:card_number) { '1234567890' }

      it { is_expected.to eq(0) }
    end

    context 'when amount is nil' do
      let(:amount) { nil }

      it { is_expected.to eq(0) }
    end
  end

  describe '#summary' do
    subject { credit_card_account.summary }

    it { is_expected.to eq("#{name}: $0") }

    context 'when card is not valid' do
      let(:card_number) { '1234567890' }

      it { is_expected.to eq("#{name}: error") }
    end
  end

  describe '#valid_card?' do
    subject { credit_card_account.valid_card? }

    it { is_expected.to be(true) }

    context 'when card is not valid' do
      let(:card_number) { '1234567890' }

      it { is_expected.to be(false) }
    end
  end
end
