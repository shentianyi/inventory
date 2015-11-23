module UsersHelper
  def role_select_options
    User::ROLES.map { |v| [v, v] }
  end
end
