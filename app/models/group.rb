class Group < ActiveRecord::Base
  #Validations
  validates :name, presence: true
  validates :members, presence: true

  #Associations
  belongs_to :user

  #Custom Save
  #Need to change display names to venmo_ids
  def convert_members(friends)
    if new_record?
      members_as_venmoid = Array.new
      names = members.split(', ')
      names.reject! { |n| n.empty? }
      names.each do |n|
        friends.each do |f|
          if f['display_name'] == n
            members_as_venmoid << f['id']
            break
          end
        end
      end
      self.members = members_as_venmoid.to_json
      return true
    else
      return false
    end
  end

  def self.get_members(group, user)
    members = Array.new();
    memberids = JSON.parse group.members
    memberids.each do |id|
      data = JSON.parse(RestClient.get('https://api.venmo.com/v1/users/' + id + '?access_token=' + user.access_token))
      members << data['data']
    end
    return members
  end
end
