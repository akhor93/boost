class Transaction < ActiveRecord::Base
  #Validations
  validates :group, presence: true
  validates :venmo_transaction_id, presence: true, uniqueness: true

  #Associations
  belongs_to :group

  def self.submit(params, user)
    group_id = params[:groupid]
    group = Group.find(group_id)
    members = JSON.parse(group.members);
    amount = params[:amount]
    if params[:type] === 'charge'
      amount.insert(0,'-');
    end
    transactions = Array.new
    members.each do |m|
      url = 'https://api.venmo.com/v1/payments'
      uri = URI.parse(url);
      res = Net::HTTP.post_form(uri, 'access_token' => user.access_token, 'user_id' => m, 'note' => params[:note], 'amount' => params[:amount], 'audience' => 'friends');
      res_json = JSON.parse res.body
      payment = res_json['data']['payment']
      transaction_params = { :group => group, :venmo_transaction_id => payment['id'] }
      transaction = Transaction.create(transaction_params)
      transactions << transaction
    end
    return transactions
  end

  def self.get_transactions_from_group(group, user)
    transactions = Array.new();
    group.transactions.each do |t|
      uri = URI('https://api.venmo.com/v1/payments/' + t.venmo_transaction_id + '?access_token=' + user.access_token)
      data = JSON.parse Net::HTTP.get(uri)
      transactions << data['data']
    end
    return transactions
  end
end
