# frozen_string_literal: true

require 'luhn'

# class for credi card accounts
class CreditCardAccount
  attr_reader :name, :card_number, :limit, :balance

  def initialize(name:, card_number:, limit:)
    @name = name.to_s
    @card_number = card_number.to_s
    @limit = int_amount(limit)
    @balance = 0
  end

  def charge(amount: 0)
    new_balance = @balance + int_amount(amount)
    return if new_balance > @limit || !valid_card?

    @balance = new_balance
  end

  def credit(amount: 0)
    return unless valid_card?

    @balance -= int_amount(amount)
  end

  def summary
    "#{@name}: #{valid_card? ? "$#{@balance}" : 'error'}"
  end

  def valid_card?
    Luhn.valid? @card_number
  end

  private

  def int_amount(amount)
    return amount if amount.is_a?(Integer)
    return 0 if amount.nil?

    amount.delete_prefix('$').to_i
  end
end
