# frozen_string_literal: true

require 'pry'

# main class app
class App
  attr_reader :accounts

  def initialize(text_input)
    @accounts = []
    text_input.each_line do |string_line|
      next if string_line.empty?

      process_line(string_line)
    end
  end

  def accounts_summary
    @accounts.sort_by(&:name).map(&:summary).join("\n")
  end

  def add_account(text_line_array)
    name = text_line_array[1]
    card_number = text_line_array[2]
    limit = text_line_array[3]

    @accounts << CreditCardAccount.new(name:, card_number:, limit:)
  end

  def find_by_name(name)
    @accounts.find { _1.name == name.to_s }
  end

  def process_line(text_line)
    text_line_array = text_line.split
    type = text_line_array[0]
    return add_account(text_line_array) if type == 'Add'

    amount = text_line_array[2]
    account = find_by_name(text_line_array[1])
    account.public_send(type.downcase.to_sym, amount:) if account.respond_to?(type.downcase.to_sym)
  end
end
