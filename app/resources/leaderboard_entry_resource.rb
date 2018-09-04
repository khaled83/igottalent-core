class LeaderboardEntryResource < JSONAPI::Resource
  attributes :name, :score, :rank

  # relationship :user, to: :one
  has_one :user, always_include_linkage_data: true
end
