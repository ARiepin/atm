class Note < ApplicationRecord
  AVAILABLE_DENOMINATIONS = [1, 2, 5, 10, 25, 50]

  class NoFundsError < StandardError; end

  def self.deposit(notes)
    Note.transaction do
      notes.each do |key, value|
        value.to_i.times { Note.create!(denomination: key) }
      end
    end
  end

  def self.withdraw(notes, amount)
    raise NoFundsError if amount > Note.balance
    Note.transaction do
      @withdrawal, @note_ids = [], []
      @withdrawn_amount = 0
      notes.each do |id, denomination|
        if @withdrawn_amount < amount
          next if denomination > amount - @withdrawn_amount
          max_note = [denomination, amount].min
          @withdrawal << max_note
          @withdrawn_amount += max_note
          @note_ids << id
        end
      end
    end
    raise NoFundsError if @withdrawn_amount != amount
    Note.where(id: @note_ids).delete_all
    @withdrawal
  end

  def self.balance
    Note.sum(&:denomination)
  end
end
