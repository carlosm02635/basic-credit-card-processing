# frozen_string_literal: true

require 'rspec'
require_relative '../app'
require_relative '../credit_card_account'

RSpec.describe App do
  subject(:app) { described_class.new(text_input) }

  let(:text_input) { '' }

  describe '#new' do
    let(:text_input) do
      "Add Tom 4111111111111111 $1000
      Add Lisa 5454545454545454 $3000"
    end

    before do
      allow_any_instance_of(described_class).to receive(:process_line).and_return(nil)
      app
    end

    it 'calls method for processing on each text line' do
      expect(app).to have_received(:process_line).twice
    end
  end

  describe '#accounts_summary' do
    subject { app.accounts_summary.to_s }

    before { app.instance_variable_set(:@accounts, accounts) }

    let(:accounts) do
      [
        double(CreditCardAccount, name: 'Tom', summary: 'Tom: $100'),
        double(CreditCardAccount, name: 'Lucy', summary: 'Lucy: error')
      ]
    end

    it { is_expected.to eq("Lucy: error\nTom: $100") }
  end

  describe '#add_account' do
    subject(:add_account) { app.add_account(text_line_array) }

    let(:text_line_array) { ['', name, card_number, limit] }
    let(:name) { 'John' }
    let(:card_number) { '5454545454545454' }
    let(:limit) { '$1000' }

    let(:account) { double(CreditCardAccount) }

    let(:expected_args) { { name:, card_number:, limit: } }

    before do
      allow(CreditCardAccount).to receive(:new).and_return(account)

      add_account
    end

    it 'initializes a new account' do
      expect(CreditCardAccount).to have_received(:new).with(expected_args)
    end

    it 'adds new account to accounts list' do
      expect(app.accounts).to match_array([account])
    end
  end

  describe '#find_by_name' do
    subject(:find_by_name) { app.find_by_name(name) }

    before { app.instance_variable_set(:@accounts, accounts) }

    let(:account_one) { double(CreditCardAccount, name: 'Jennifer') }
    let(:accounts) { [account_one, double(CreditCardAccount, name: 'Eddy')] }

    context 'when we look for an existing name' do
      let(:name) { account_one.name }

      it { is_expected.to eq(account_one) }
    end

    context 'when we look for an inexisting name' do
      let(:name) { 'unexistent' }

      it { is_expected.to be_nil }
    end
  end

  describe '#process_line' do
    subject(:process_line) { app.process_line(text_line) }

    let(:account) { double(CreditCardAccount, name: 'Roy') }

    before do
      allow(app).to receive(:add_account).and_return(nil)

      allow(account).to receive(:charge).and_return(nil)
      allow(account).to receive(:credit).and_return(nil)
    end

    context 'when the line contains "Add"' do
      let(:text_line) { 'Add Matt 4111111111111111 $1000' }

      before { process_line }

      it 'calls method for adding a new account' do
        expect(app).to have_received(:add_account).with(text_line.split)
      end
    end

    %w[Charge Credit].each do |method|
      context "when the line contains #{method}" do
        let(:text_line) { "#{method} Roy $200" }

        context 'when account exists' do
          before do
            app.instance_variable_set(:@accounts, [account])

            process_line
          end

          it "calls method for #{method} account" do
            expect(account).to have_received(method.downcase.to_sym).with(amount: '$200')
          end
        end

        context 'when account does not exist' do
          before { process_line }

          it "does not call method for #{method} account" do
            expect(account).not_to have_received(method.downcase.to_sym)
          end
        end
      end
    end

    context 'when the line does not contain Add, Charge, Credit' do
      let(:text_line) { 'unknown Matt 4111111111111111 $1000' }

      before { process_line }

      it 'does not call any method' do
        expect(account).not_to have_received(:charge)
        expect(account).not_to have_received(:credit)
        expect(app).not_to have_received(:add_account)
      end
    end
  end
end
