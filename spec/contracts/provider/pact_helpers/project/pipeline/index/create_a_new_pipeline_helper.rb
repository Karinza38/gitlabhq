# frozen_string_literal: true

require_relative "../../../../spec_helper"
require_relative "../../../../helpers/contract_source_helper"
require_relative "../../../../helpers/publish_contract_helper"
require_relative "../../../../states/project/pipeline/new_state"

module Provider
  module CreateNewPipelineHelper
    Pact.service_provider "POST Create a new pipeline" do
      app { Environments::Test.app }

      honours_pact_with "Pipelines#new" do
        pact_uri Provider::ContractSourceHelper.contract_location(:CREATE_A_NEW_PIPELINE, :spec)
      end

      Provider::PublishContractHelper.publish_contract_setup.call(
        method(:app_version),
        method(:app_version_branch),
        method(:publish_verification_results)
      )
    end
  end
end
