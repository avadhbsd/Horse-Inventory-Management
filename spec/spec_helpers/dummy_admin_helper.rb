# frozen_string_literal: true

module DummyAdminHelper
  def create_random_admin
    Admin.create(email: 'a@a.a', password: '123456')
  end

  def sign_in_random_admin
    sign_in(create_random_admin)
  end
end
