class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.belongs_to :user, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :email
      t.datetime :email_confirmation_at

      t.string :enter_email_token
      t.datetime :enter_email_token_expires_at

      t.string :confirm_email_token
      t.datetime :confirm_email_token_expires_at

      t.timestamps
    end

    add_index :authorizations, [:uid, :provider]
  end
end
