# Security Policy

## Supported Versions

Currently, only the latest version of Field Inspector is supported with security updates.

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly.

### How to Report

1. **Do not create a public issue** - Security vulnerabilities should be reported privately
2. **Send an email** to the project maintainers
3. **Include the following information**:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact
   - Suggested fix (if known)

### What to Expect

- We will acknowledge receipt of your report within 48 hours
- We will provide a detailed response within 7 days
- We will work with you to understand and fix the issue
- We will coordinate disclosure of the vulnerability

### Security Best Practices

This app follows these security practices:

- **Minimal Permissions**: Only requests necessary permissions
- **Secure Storage**: Uses secure storage for sensitive data
- **Permission Handling**: Proper runtime permission requests
- **Data Privacy**: No user data is transmitted externally
- **Code Review**: All code goes through review process

### Known Security Considerations

- **Location Data**: GPS coordinates are stored locally on device
- **Camera Access**: Camera is only used when app is active
- **Storage**: Photos are stored in app's private storage
- **Network**: No network communication for core features

## Security Checklist

- [x] Runtime permission requests
- [x] Secure storage for sensitive data
- [x] No hardcoded credentials
- [x] Input validation
- [x] Error handling without information leakage
- [x] Third-party library vetting
- [ ] Security audit (pending)
- [ ] Penetration testing (pending)

## Dependency Management

We regularly update dependencies to include security patches. Dependabot is configured to automatically create pull requests for dependency updates.

## License

This project is licensed under the MIT License. See LICENSE file for details.