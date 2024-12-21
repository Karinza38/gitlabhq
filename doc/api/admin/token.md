---
stage: Software Supply Chain Security
group: Authentication
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://handbook.gitlab.com/handbook/product/ux/technical-writing/#assignments
description: "Documentation for the REST API that exposes token information."
---

# Token information API

DETAILS:
**Tier:** Free, Premium, Ultimate
**Offering:** Self-managed
**Status:** Experiment

Use this API to retrieve details about arbitrary tokens and to revoke them. Unlike other APIs that expose token information, this API allows you to retrieve details or revoke tokens without knowing the specific type of token.

Prerequisites:

- You must have administrator access to the instance.

## Get information on a token

> - [Introduced](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/165157) in GitLab 17.5 [with a flag](../../administration/feature_flags.md) named `admin_agnostic_token_finder`. Disabled by default.
> - [Feed tokens added](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169821) in GitLab 17.6.
> - [OAuth application secrets added](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/172985) in GitLab 17.7.
> - [Cluster agent tokens added](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/172932) in GitLab 17.7.
> - [Runner authentication tokens added](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/173987) in GitLab 17.7.
> - [Pipeline trigger tokens added](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/174030) in GitLab 17.7.

FLAG:
The availability of this feature is controlled by a feature flag.
For more information, see the history.
This feature is available for testing, but not ready for production use.

Gets information for a given token. This endpoint supports the following token types:

- [Personal access tokens](../../user/profile/personal_access_tokens.md)
- [Impersonation tokens](../../api/rest/authentication.md#impersonation-tokens)
- [Deploy tokens](../../user/project/deploy_tokens/index.md)
- [Feed tokens](../../security/tokens/index.md#feed-token)
- [OAuth application secrets](../../integration/oauth_provider.md)
- [Cluster agent tokens](../../security/tokens/index.md#gitlab-cluster-agent-tokens)
- [Runner authentication tokens](../../security/tokens/index.md#runner-authentication-tokens)
- [Pipeline trigger tokens](../../ci/triggers/index.md#create-a-pipeline-trigger-token)

```plaintext
POST /api/v4/admin/token
```

Supported attributes:

| Attribute    | Type    | Required | Description                |
|--------------|---------|----------|----------------------------|
| `token`      | string  | Yes      | Existing token to identify |

If successful, returns [`200`](../rest/troubleshooting.md#status-codes) and information about the token.

Can return the following status codes:

- `200 OK`: Information about the token.
- `401 Unauthorized`: The user is not authorized.
- `403 Forbidden`: The user is not an administrator.
- `404 Not Found`: The token was not found.
- `422 Unprocessable`: The token type is not supported.

Example request:

```shell
curl --request POST \
  --url "https://gitlab.example.com/api/v4/admin/token" \
  --header "PRIVATE-TOKEN: <your_access_token>" \
  --header 'Content-Type: application/json' \
  --data '{"token": "glpat-<example-token>"}'
```

Example response:

```json
{
 "id": 1,
 "user_id": 70,
 "name": "project-access-token",
 "revoked": false,
 "expires_at": "2024-10-04",
 "created_at": "2024-09-04T07:19:18.652Z",
 "updated_at": "2024-09-04T07:19:18.652Z",
 "scopes": [
  "api",
  "read_api"
 ],
 "impersonation": false,
 "expire_notification_delivered": false,
 "last_used_at": null,
 "after_expiry_notification_delivered": false,
 "previous_personal_access_token_id": null,
 "advanced_scopes": null,
 "organization_id": 1
}
```

## Revoke a token

> - [Introduced](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/170421) in GitLab 17.7 [with a flag](../../administration/feature_flags.md) named `api_admin_token_revoke`. Disabled by default.

FLAG:
The availability of this feature is controlled by a feature flag.
For more information, see the history.
This feature is available for testing, but not ready for production use.

Revokes a given token. This endpoint supports the following token types:

- [Personal access tokens](../../user/profile/personal_access_tokens.md)
- [Project access tokens](../../security/tokens/index.md#project-access-tokens)
- [Group access tokens](../../security/tokens/index.md#group-access-tokens)
- [Deploy tokens](../../user/project/deploy_tokens/index.md)
- [Feed tokens](../../security/tokens/index.md#feed-token)

```plaintext
DELETE /api/v4/admin/token
```

Supported attributes:

| Attribute    | Type    | Required | Description              |
|--------------|---------|----------|--------------------------|
| `token`      | string  | Yes      | Existing token to revoke |

If successful, returns [`204`](../rest/troubleshooting.md#status-codes) without content.

Can return the following status codes:

- `204 No content`: Token has been revoked.
- `401 Unauthorized`: The user is not authorized.
- `403 Forbidden`: The user is not an administrator.
- `404 Not Found`: The token was not found.
- `422 Unprocessable`: The token type is not supported.

Example request:

```shell
curl --request DELETE \
  --url "https://gitlab.example.com/api/v4/admin/token" \
  --header "PRIVATE-TOKEN: <your_access_token>" \
  --header 'Content-Type: application/json' \
  --data '{"token": "glpat-<example-token>"}'
```
