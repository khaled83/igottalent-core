module Boards
  class GetAllService < Boards::Base
    def execute(options = {})
      members = leaderboard.leaders(
        page(options).to_i,
        page_size: page_size(options)
      )
      members.each do |member|
        data = leaderboard.member_data_for(member[:member])
        member[:id]      = JSON.parse(data)['id']
        member[:user_id] = JSON.parse(data)['user_id']
      end
      members
    end

    private

    def page(options)
      options[:page] || 1
    end

    def page_size(options)
      options[:page_size] || 10
    end
  end
end
