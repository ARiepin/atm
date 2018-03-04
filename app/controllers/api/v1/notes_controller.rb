class Api::V1::NotesController < Api::V1::ApiController
  def deposit
    if Note.deposit(params[:notes])
      render json: { message: 'Notes succesfully deposited' }, status: 200
    else
      render json: { errors: { message: 'Unable to proceed. Please try again later' } }
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: { message: e.message } }
  end

  def withdraw
    notes = Note.order(denomination: :desc).pluck(:id, :denomination)
    withdrawal = Note.withdraw(notes, params[:amount].to_i)
    render json: withdrawal, status: 200
  rescue Note::NoFundsError
    render json: { errors: { message: 'Unable to proceed. Please specify another amount' }}
  end
end
