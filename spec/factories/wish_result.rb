FactoryGirl.define do
    factory :wish_result do
        wish
        nzb_id 'abcd1234'
        title 'Test Result'
        category
        pub_date Time.now
        size 123456789
        details_url 'http://localhost'
        downloaded false
    end
end