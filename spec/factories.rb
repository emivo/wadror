FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Lorem1"
    password_confirmation "Lorem1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :style do
    name "lager"
    description "Perus bissee"
  end

  factory :beer do
    name "anonymous"
    brewery
    style
  end

end