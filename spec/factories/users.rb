FactoryGirl.define do
 factory :user do
   sequence(:email) {|i| "user#{i}@lagoon-mgr.test"}
   sequence(:password) {|i| "password#{i}"}
   sequence(:password_confirmation) {|i| "password#{i}"}
   sequence(:username) {|i| "User #{i}"}

   trait :admin do
     is_admin true
   end

   trait :reviewer do
     is_reviewer true
   end
 end
end
