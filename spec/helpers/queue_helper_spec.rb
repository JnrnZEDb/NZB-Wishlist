require 'spec_helper'

RSpec.describe QueueHelper do
    describe '#format_category' do
        it 'titlecases categories greater than 3 characters' do
            result = helper.format_category('testing')
            expect(result).to eq 'Testing'
        end

        it 'uppercases categories less than or equal to 3 characters' do
            result = helper.format_category('osx')
            expect(result).to eq 'OSX'
        end

        it "transforms * into 'Default'" do
            result = helper.format_category('*')
            expect(result).to eq 'Default'
        end
    end
end