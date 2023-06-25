# frozen_string_literal: true

require 'rspec'
require_relative '../../app'
require_relative '../../credit_card_account'

RSpec.describe 'Credit Card Account App' do
  subject(:app_instance) { App.new(input) }

  let(:input) do
    "Add Tom 4111111111111111 $1000
    Add Lisa 5454545454545454 $3000
    Add Quincy 1234567890123456 $2000
    Charge Tom $500
    Charge Tom $800
    Charge Lisa $7
    Credit Lisa $100
    Credit Quincy $200
    undef Gerald $100
    Charge Gerald $7"
  end

  describe '#accounts_summary' do
    subject { app_instance.accounts_summary }

    it { is_expected.to eq("Lisa: $-93\nQuincy: error\nTom: $500") }
  end
end
