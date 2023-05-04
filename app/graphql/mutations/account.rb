# frozen_string_literal: true

class Mutations::Account < Mutations::Namespace
  field :send_password_reset,
    mutation: Mutations::Account::SendPasswordReset,
    description: 'Send a password reset email'
  field :change_password, mutation: Mutations::Account::ChangePassword
end
