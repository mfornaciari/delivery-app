# frozen_string_literal: true

class Address < ApplicationRecord
  validates :line1, :city, :state, presence: true

  enum state: {
    AC: 0,
    AL: 5,
    AP: 10,
    AM: 15,
    BA: 20,
    CE: 25,
    DF: 30,
    ES: 35,
    GO: 40,
    MA: 45,
    MT: 50,
    MS: 55,
    MG: 60,
    PA: 65,
    PB: 70,
    PR: 75,
    PE: 80,
    PI: 85,
    RJ: 90,
    RN: 95,
    RS: 100,
    RO: 105,
    RR: 110,
    SC: 115,
    SP: 120,
    SE: 125,
    TO: 130
  }
end
