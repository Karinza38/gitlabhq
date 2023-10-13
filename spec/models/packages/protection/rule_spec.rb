# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Packages::Protection::Rule, type: :model, feature_category: :package_registry do
  it_behaves_like 'having unique enum values'

  describe 'relationships' do
    it { is_expected.to belong_to(:project).inverse_of(:package_protection_rules) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:package_type).with_values(npm: Packages::Package.package_types[:npm]) }

    it {
      is_expected.to(
        define_enum_for(:push_protected_up_to_access_level)
          .with_values(
            developer: Gitlab::Access::DEVELOPER,
            maintainer: Gitlab::Access::MAINTAINER,
            owner: Gitlab::Access::OWNER
          )
          .with_prefix(:push_protected_up_to)
      )
    }
  end

  describe 'validations' do
    subject { build(:package_protection_rule) }

    describe '#package_name_pattern' do
      it { is_expected.to validate_presence_of(:package_name_pattern) }
      it { is_expected.to validate_uniqueness_of(:package_name_pattern).scoped_to(:project_id, :package_type) }
      it { is_expected.to validate_length_of(:package_name_pattern).is_at_most(255) }
    end

    describe '#package_type' do
      it { is_expected.to validate_presence_of(:package_type) }
    end

    describe '#push_protected_up_to_access_level' do
      it { is_expected.to validate_presence_of(:push_protected_up_to_access_level) }
    end
  end
end
