FactoryGirl.define do
  factory :applist do

    trait :valid do
      google_play_url "https://play.google.com/store/apps/details?id=com.kakao.talk"
      itunes_url "https://itunes.apple.com/in/app/kakaotalk/id362057947"
    end

    trait :blank_google_play_url do
      itunes_url "https://itunes.apple.com/in/app/kakaotalk/id362057947"
    end

    trait :blank_itunes_url do
      google_play_url "https://play.google.com/store/apps/details?id=com.kakao.talk"
    end

    trait :invalid do
      google_play_url "https://play.google.com/store/apps/details?id=exampleexampleexampleexample"
      itunes_url "https://itunes.apple.com/in/app/exampleexampleexample/id0123456789"
    end

    trait :invalid_google_play_url do
      google_play_url "https://play.google.com/store/apps/details?id=exampleexampleexampleexample"
      itunes_url "https://itunes.apple.com/in/app/kakaotalk/id362057947"
    end

    trait :invalid_itunes_url do
      google_play_url "https://play.google.com/store/apps/details?id=com.kakao.talk"
      itunes_url "https://itunes.apple.com/in/app/exampleexampleexample/id0123456789"
    end
  end
end
