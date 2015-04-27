FactoryGirl.define do
    factory :category do
        name 'Test Category'
        canonical_name 'Test Category'
    end

    trait :sub_category do
        name 'Sub Category'
        parent
        canonical_name 'Test Category/Sub Category'
    end
end