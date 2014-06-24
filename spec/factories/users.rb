FactoryGirl.define do
  factory :user do
    login 'leander-taler'
    email 'leander-taler@test.com'
    password 'secret1234'
    password_confirmation 'secret1234'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
    
    factory :admin do
      login "heinz-schenk"
      email "heinz-schenk@test.com"
      admin true
    end
  end
end

