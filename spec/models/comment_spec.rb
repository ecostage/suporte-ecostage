require 'spec_helper'

describe Comment do
  describe 'validations' do
    context 'when there is a empty content' do
      it 'can not return a comment object with empty errors' do
        comment = Comment.new(content: '')

        comment.save

        expect(comment.errors).not_to be_empty
      end
    end
  end

  describe '.recently_first' do
    it 'returns recently comments first' do
      create(:comment, content: 'first')
      create(:comment, content: 'second')
      create(:comment, content: 'third')

      expect(Comment.recently_first.map(&:content)).to eq ['third', 'second', 'first']
    end
  end
end
