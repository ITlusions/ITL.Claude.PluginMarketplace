# Developer Plugin

Software development lifecycle toolkit with expertise in Git workflows, CI/CD pipelines, version management, testing strategies, Python code organization, and developer tooling.

## Components

### Agent: `developer`

A comprehensive development agent covering:

- **Git & Version Control**: GitFlow, branching strategies, tagging, merge strategies
- **Versioning & Release Management**: Semantic versioning, release workflows, hotfixes
- **CI/CD & Pipeline Automation**: Azure DevOps, GitHub Actions, build automation
- **Testing & QA**: Unit, integration, E2E testing, coverage analysis
- **Python Code Organization**: Using the `python-app-guidelines` skill (loads automatically)
- **Build & Dependency Management**: Package managers, versioning, vulnerability scanning
- **Development Workflows**: Code review, PRs, commit conventions, environment setup
- **Tooling & Command Line**: PowerShell, Bash, Git CLI, Docker

## Quick Start

```
@developer Help me set up GitFlow for my team
@developer Review my Python project structure
@developer Design a CI/CD pipeline for my Node.js app
```

## Skills

- **python-app-guidelines**: Automatically loaded when discussing Python code organization. Covers src-layout, class placement, dependency injection, and naming conventions.

## Git Conventions

### Commit Messages
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Branch Naming
```
feature/<description>       # New features
bugfix/<description>        # Bug fixes
hotfix/<version>            # Production hotfixes
release/<version>           # Release branches
```

### Semantic Versioning
```
v<major>.<minor>.<patch>[-label.<buildId>]
```

## Tools & Technologies

- **Version Control**: Git, GitHub, Azure DevOps, GitLab
- **CI/CD**: Azure Pipelines, GitHub Actions, Jenkins, GitLab CI
- **Build Tools**: MSBuild, Gradle, Maven, npm/yarn, webpack
- **Testing**: Jest, pytest, xUnit, Mocha, Cypress, Selenium
- **Containers**: Docker, Docker Compose, Kubernetes
- **Scripting**: PowerShell, Bash, Python
- **Code Quality**: SonarQube, ESLint, Prettier, coverage tools
- **Package Management**: NuGet, npm, Maven Central, PyPI
- **Monitoring**: Application Insights, ELK Stack, Prometheus

## Version

**1.0.0** - Initial migration from ITL.Agents Developer custom agent

---

**Authored by**: Niels Weistra  
**Repository**: https://github.com/ITlusions/ITL.Claude.PluginMarketplace  
**License**: MIT
