# frozen_string_literal: true

module QA
  RSpec.describe 'Package', :orchestrated, :packages do
    describe 'Generic Repository' do
      let(:package_name) { 'my_package' }

      let(:project) do
        Resource::Project.fabricate_via_api! do |project|
          project.name = 'generic-package-project'
        end
      end

      let!(:runner) do
        Resource::Runner.fabricate! do |runner|
          runner.name = "qa-runner-#{Time.now.to_i}"
          runner.tags = ["runner-for-#{project.name}"]
          runner.executor = :docker
          runner.project = project
        end
      end

      let(:gitlab_ci_yaml) do
        <<~YAML
          image: curlimages/curl:latest

          stages:
            - upload
            - download

          upload:
            stage: upload
            script:
              - 'curl --header "JOB-TOKEN: $CI_JOB_TOKEN" --upload-file file.txt ${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/my_package/0.0.1/file.txt'
            tags:
              - "runner-for-#{project.name}"
          download:
            stage: download
            script:
              - 'wget --header="JOB-TOKEN: $CI_JOB_TOKEN" ${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/my_package/0.0.1/file.txt -O file_downloaded.txt'
            tags:
              - "runner-for-#{project.name}"
        YAML
      end

      let(:file_txt) do
        <<~EOF
          Hello, world!
        EOF
      end

      before do
        Flow::Login.sign_in

        Resource::Repository::Commit.fabricate_via_api! do |commit|
          commit.project = project
          commit.commit_message = 'Add .gitlab-ci.yml'
          commit.add_files([{
                                file_path: '.gitlab-ci.yml',
                                content: gitlab_ci_yaml
                            },
                            {
                                file_path: 'file.txt',
                                content: file_txt
                            }]
                          )
        end

        project.visit!
        Page::Project::Menu.perform(&:click_ci_cd_pipelines)
        Page::Project::Pipeline::Index.perform(&:click_on_latest_pipeline)

        Page::Project::Pipeline::Show.perform do |pipeline|
          pipeline.click_job('upload')
        end

        Page::Project::Job::Show.perform do |job|
          expect(job).to be_successful(timeout: 800)

          job.click_element(:pipeline_path)
        end

        Page::Project::Pipeline::Show.perform do |pipeline|
          pipeline.click_job('download')
        end

        Page::Project::Job::Show.perform do |job|
          expect(job).to be_successful(timeout: 800)
        end
      end

      after do
        runner.remove_via_api!
      end

      it 'uploads a generic package, downloads and deletes it', testcase: 'https://gitlab.com/gitlab-org/quality/testcases/-/issues/1108' do
        Page::Project::Menu.perform(&:click_packages_link)

        Page::Project::Packages::Index.perform do |index|
          expect(index).to have_package(package_name)
          index.click_package(package_name)
        end

        Page::Project::Packages::Show.perform do |package|
          package.click_delete
        end

        Page::Project::Packages::Index.perform do |index|
          aggregate_failures 'package deletion' do
            expect(index).to have_content("Package deleted successfully")
            expect(index).to have_no_package(package_name)
          end
        end
      end
    end
  end
end
