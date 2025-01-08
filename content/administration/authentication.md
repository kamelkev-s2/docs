---
title: Authentication
weight: 15
---

# Authentication

Selector supports robust authentication controls based upon Role-Based Access Control (RBAC) and Single-Sign On to ensure that users are granted appropriate permissions based on their roles within the organization.

### Capabilities

- **Standards Based** - The system is based on OAuth2/OpenID Connect standards, ensuring industry-wide compatibility and security.

- **Granular Control** - Selector enforces access controls without requiring modifications to your services' code.

- **Flexible Roles** - The system offers an expandable list of user-managed roles, including system roles like ADMIN, REGULAR, and READONLY.

- **Fine-Grained Permissions** - RBAC is implemented with a focus on specific permissions granted to roles, ensuring a more refined level of access control.  

- **Secure Token Handling** - JWT tokens are only exchanged between Kong and backend services, ensuring token security.

- **Efficient Key Management** - Users can manage their own keys per application, enhancing security and convenience.

- **Granular API Key Control** - API keys are now tied to users and their roles/permissions, offering improved access control.

### Client Credentials Flow

The Client Credentials Flow allows applications to pass their Client Secret and Client ID to an authorization server, which authenticates the user, and returns a token. The workflow is as follows:

- User Authentication - Users authenticate using their credentials (email and password).

- Token Generation - Upon successful authentication, Keycloak generates a signed JWT token containing user roles and permissions.

- Token Storage - The JWT token is stored securely within Kong and passed only between Kong and your backend services.

- Access Control - Kong enforces API-level access controls using the openid-connect plugin, validating tokens against Keycloak's claims.

- Authorization - Based on the token's roles and permissions, Kong makes authorization decisions for each service request.

![alt text](/images/authentication.png "Authentication Workflow")

### API Key Authentication

### Request Sent

An opaque API key is included in the authorization header of the request.  
Validation Process: Kong queries S2-IAM to validate the API key (existence, status, expiration, etc.).

### Token Issuance and Verification

S2-IAM consults Keycloak to verify the user's roles and fetch corresponding permissions. If valid, Kong receives a JWT token mapped to the user's permissions. Kong caches the introspection result for efficient subsequent access control checks.

### Single Sign-On

Selector natively supports popular Single Sign-On (SSO) providers, allowing users to log in with their existing credentials. 

SSO authentication allows for simplified user experience, centralized identity management, enhanced security with strong authentication measures, automated user provisioning and de-provisioning, audit trail and compliance support, seamless integration with existing infrastructure, and time and cost savings. SSO improves user convenience, security, and administrative efficiency.

#### Supported Mechanisms

##### Microsoft SSO

Azure Active Directory (Azure AD): Azure AD is Microsoft's cloud-based identity and access management service. It serves as the primary identity provider for Microsoft SSO. Azure AD supports industry-standard SSO protocols like SAML, OpenID Connect, and OAuth.

##### Google SSO

Google offers various SSO solutions that streamline the authentication process and enhance user convenience within the Google ecosystem. 

##### Okta SSO

Okta provides an identity and access management (IAM) platform. Okta SSO enables users to access multiple applications and services with a single set of credentials, enhancing user convenience and simplifying authentication.

##### PingFederate SSO

PingFederate is an enterprise federation server that enables user authentication and single sign-on. It serves as a global authentication authority that allows customers, employees, and partners to securely access all the applications they need from any device.
