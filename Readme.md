# Basic Credit Card Processing

## Overview
It includes the required basic functions: adding new credit card accounts, processing charges and credits against them, and display summary information.

The program consist of two classes; one called `CreditCardAccount` which handles all the things related to the account, and one called `App` which handles all the app logic. I kept it simple only with the basic operations. The repo includes unit tests for each class and one integration test testing the behavior when an input is provided. It's built in `Ruby` as it is the languaje I feel most comfortable working with.

## Dependencies
The app was built using `Ruby 3.1.2` but any recent version should work fine.
In order to install needed dependences, after cloning the repository just run in console:
```
bundle install
```

## Using it
In order to use the app you need to provide a string input through a .txt file (the repo inludes an `input.txt` as a reference but you can provide your own).
It accepts the following three input commands passed with space delimited
arguments:
- `Add`: creates a new credit card for a given name, card number, and limit.
- `Charge`: increases the balance of the card associated with the provided name by the
amount specified.
- `Credit`: decreases the balance of the card associated with the provided name by the
amount specified.

Input example:
```
Add Steven 4111111111111111 $1000
Charge Steven $200
Credit Steven $50
```

You can provide the input in two different ways:
1. A filename passed as a command line argument:
```
ruby main.rb input.txt
```
2. Input read from STDIN:
```
ruby main.rb < input.txt
```

## Testing
It includes unit tests for the classes and one integration test. You can run them with:
```
bundle exec rspec -fd
```
