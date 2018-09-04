# Mandatory to allow api resource to work
# Entries are stored in Redis, not in Postgres, ActiveRecord is not used for that
class LeaderboardEntry < ApplicationRecord
end
