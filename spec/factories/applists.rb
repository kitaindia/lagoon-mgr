FactoryGirl.define do
  factory :applist do

    google_play_url "https://play.google.com/store/apps/details?id=com.kakao.talk"
    itunes_url "https://itunes.apple.com/in/app/kakaotalk/id362057947"

    trait :without_google_play_url do
      google_play_url nil
    end

    trait :with_invalid_google_play_url do
      google_play_url "https://play.google.com/store/apps/details?id=exampleexampleexampleexample"
    end

    trait :without_itunes_url do
      itunes_url nil
    end

    trait :with_invalid_itunes_url do
      itunes_url "https://itunes.apple.com/in/app/exampleexampleexample/id0123456789"
    end
  end
end
