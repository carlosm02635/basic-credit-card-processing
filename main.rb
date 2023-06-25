# frozen_string_literal: true

require 'pry'
require_relative './credit_card_account'
require_relative './app'

filename = ARGV[0]
content = filename.nil? ? ARGF.read : File.read(filename)

if content.empty?
  puts 'No input provided.'
  exit
end

app = App.new(content)
puts app.accounts_summary
