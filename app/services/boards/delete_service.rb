module Boards
  class DeleteService < Boards::Base
    def execute(options = {})
      user = User.find(options[:id])
      return false unless user.present?
      name = user.email
      return false unless member_exists?(name)
      return leaderboard.remove_member(name).first
    end

    private

    def member_exists?(name)
      leaderboard.check_member?(name)
    end
  end
end
