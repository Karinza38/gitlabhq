import { GlLink, GlSprintf } from '@gitlab/ui';
import { shallowMount } from '@vue/test-utils';
import { helpPagePath } from '~/helpers/help_page_helper';
import SettingsBlock from '~/vue_shared/components/settings/settings_block.vue';
import ContainerRegistrySection from '~/packages_and_registries/settings/project/components/container_registry_section.vue';
import ContainerExpirationPolicy from '~/packages_and_registries/settings/project/components/container_expiration_policy.vue';
import ContainerProtectionRules from '~/packages_and_registries/settings/project/components/container_protection_rules.vue';
import ContainerProtectionTagRules from '~/packages_and_registries/settings/project/components/container_protection_tag_rules.vue';

describe('Container registry project settings section', () => {
  let wrapper;

  const findSettingsBlock = () => wrapper.findComponent(SettingsBlock);
  const findLink = () => findSettingsBlock().findComponent(GlLink);
  const findContainerExpirationPolicy = () => wrapper.findComponent(ContainerExpirationPolicy);
  const findContainerProtectionRules = () => wrapper.findComponent(ContainerProtectionRules);
  const findContainerProtectionTagRules = () => wrapper.findComponent(ContainerProtectionTagRules);

  const defaultProvide = {
    glFeatures: {
      containerRegistryProtectedContainers: true,
      containerRegistryProtectedTags: true,
    },
  };

  const mountComponent = (provide = defaultProvide) => {
    wrapper = shallowMount(ContainerRegistrySection, {
      provide,
      stubs: {
        GlSprintf,
      },
    });
  };

  describe('settings', () => {
    beforeEach(() => {
      mountComponent();
    });

    it('renders with title', () => {
      expect(findSettingsBlock().props('title')).toBe('Container registry');
    });

    it('renders with description', () => {
      expect(findSettingsBlock().text()).toBe(
        'The GitLab Container Registry is a secure and private registry for container images. It’s built on open source software and completely integrated within GitLab. Use GitLab CI/CD to create and publish images. Use the GitLab API to manage the registry across groups and projects.',
      );
    });

    it('renders the help page link with correct href', () => {
      const link = findLink();
      const docsPath = helpPagePath('/user/packages/container_registry/index.md');

      expect(link.attributes('href')).toBe(docsPath);
    });

    it('renders container registry settings components', () => {
      mountComponent();

      expect(findContainerExpirationPolicy().exists()).toBe(true);
      expect(findContainerProtectionRules().exists()).toBe(true);
      expect(findContainerProtectionTagRules().exists()).toBe(true);
    });

    describe('when feature flag "containerRegistryProtectedContainers" is disabled', () => {
      it('container protection rules settings is hidden', () => {
        mountComponent({
          ...defaultProvide,
          glFeatures: { containerRegistryProtectedContainers: false },
        });

        expect(findContainerProtectionRules().exists()).toBe(false);
        expect(findContainerExpirationPolicy().exists()).toBe(true);
      });
    });

    describe('when feature flag "containerRegistryProtectedTags" is disabled', () => {
      it('container protection tag rules settings is hidden', () => {
        mountComponent({
          ...defaultProvide,
          glFeatures: { containerRegistryProtectedTags: false },
        });

        expect(findContainerExpirationPolicy().exists()).toBe(true);
        expect(findContainerProtectionRules().exists()).toBe(false);
        expect(findContainerProtectionTagRules().exists()).toBe(false);
      });
    });
  });
});
