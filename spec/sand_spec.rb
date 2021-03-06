require 'spec_helper'

RSpec.describe Sand do
  class PostPolicy < Struct.new(:user, :post) # rubocop:disable Style/StructInheritance
    def update?
      post.user == user
    end

    def destroy?
      false
    end

    def show?
      true
    end
  end

  class PostPolicy::Scope < Struct.new(:user, :scope) # rubocop:disable Style/StructInheritance, Style/ClassAndModuleChildren
    def resolve
      scope.published
    end
  end

  class Post < Struct.new(:user) # rubocop:disable Style/StructInheritance
    def self.published
      :published
    end

    def to_s
      'Post'
    end

    def inspect
      '#<Post>'
    end
  end

  let(:user) { double }
  let(:post) { Post.new(user) }

  describe '.authorize' do
    it 'infers the policy and authorizes based on it' do
      expect(Sand.authorize(user, post, :update?)).to be_truthy
    end

    it 'raises an error with a query and action' do
      expect { Sand.authorize(user, post, :destroy?) }.to raise_error(Sand::NotAuthorizedError, 'not allowed to destroy? this #<Post>') do |error|
        expect(error.query).to eq :destroy?
        expect(error.record).to eq post
        expect(error.policy).to eq Sand.policy!(user, post)
      end
    end
  end

  describe '.policy_scope' do
    it 'returns an instantiated policy scope given a plain model class' do
      expect(Sand.policy_scope(user, Post)).to eq :published
    end

    it 'uses Model.policy if it is defined' do
      class NonStandardPolicyKlass < Struct.new(:user) # rubocop:disable Style/StructInheritance
        class Scope < Struct.new(:user, :resource) # rubocop:disable Style/StructInheritance
          def resolve
            :resolved
          end
        end
      end
      class NonStandardKlass
        def to_s
          'WillBreak'
        end

        def self.sand_policy
          NonStandardPolicyKlass
        end
      end

      expect(Sand.policy_scope(user, NonStandardKlass)).to eq(:resolved)
    end
  end

  describe '.policy!' do
    it 'rests on default NameErrors if policy does not exist' do
      class Foo
      end

      expect do
        Sand.policy!(user, Foo)
      end.to raise_error Sand::NotDefinedError
    end

    it 'succesfully finds a policy if one is defined' do
      policy = Sand.policy!(user, post)
      expect(policy).to be_an_instance_of(PostPolicy)
    end
  end
end
