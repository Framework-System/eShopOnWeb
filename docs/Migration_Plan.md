
# eShopOnWeb Migration Plan
## From .NET Core 2.1 to .NET 6.0

**Document Version:** 1.0  
**Date:** July 15, 2025  
**Project:** eShopOnWeb Reference Application  

---

## Executive Summary

This document outlines the comprehensive migration plan for upgrading the eShopOnWeb project from .NET Core 2.1 to .NET 6.0. The plan follows a phased approach to minimize risk and ensure thorough validation at each step.

**Migration Scope:** Complete application stack migration  
**Estimated Duration:** 3-4 weeks  
**Risk Level:** Medium  
**Team Size Required:** 2-3 developers  

---

## Migration Objectives

### Primary Goals
- Upgrade all projects to .NET 6.0
- Maintain existing functionality and performance
- Improve application performance and security
- Ensure compatibility with modern development tools
- Update all dependencies to supported versions

### Success Criteria
- All projects compile successfully on .NET 6.0
- All existing tests pass
- Application functionality remains intact
- Performance metrics meet or exceed current benchmarks
- Security posture is maintained or improved

---

## Prerequisites

### Development Environment
- [ ] .NET 6.0 SDK installed (version 6.0.x or later)
- [ ] Visual Studio 2022 or Visual Studio Code with C# extension
- [ ] SQL Server LocalDB or SQL Server instance
- [ ] Docker Desktop (for containerized testing)
- [ ] Git client configured

### Team Preparation
- [ ] Team trained on .NET 6.0 changes and new features
- [ ] Migration documentation reviewed by all team members
- [ ] Development environment standardized across team
- [ ] Backup and rollback procedures established

### Infrastructure Preparation
- [ ] Development databases backed up
- [ ] CI/CD pipeline reviewed for .NET 6.0 compatibility
- [ ] Testing environments prepared
- [ ] Monitoring and logging systems ready

---

## Migration Strategy

### Approach: Incremental Layer-by-Layer Migration
1. **Bottom-Up Approach:** Start with core libraries, then move to applications
2. **Parallel Development:** Maintain current version while migrating
3. **Continuous Testing:** Validate each step before proceeding
4. **Rollback Ready:** Maintain ability to revert at any stage

### Branch Strategy
```
main (production - .NET Core 2.1)
├── develop (current development)
└── feature/dotnet6-migration
    ├── phase1-core-libraries
    ├── phase2-infrastructure
    ├── phase3-web-applications
    └── phase4-testing-deployment
```

---

## Phase 1: Core Libraries Migration (Week 1)

### Scope
- ApplicationCore project
- Update shared dependencies
- Validate domain logic compatibility

### Tasks

#### 1.1 ApplicationCore Project Migration
**Duration:** 2 days  
**Assignee:** Senior Developer  

**Steps:**
1. Update `ApplicationCore.csproj`:
   ```xml
   <TargetFramework>net6.0</TargetFramework>
   ```

2. Update NuGet packages:
   ```xml
   <PackageReference Include="Ardalis.GuardClauses" Version="4.0.1" />
   <PackageReference Include="System.Security.Claims" Version="4.3.0" />
   ```

3. Compile and resolve any compilation errors
4. Run unit tests targeting ApplicationCore

**Validation Criteria:**
- [ ] Project compiles without errors
- [ ] All domain entities and services function correctly
- [ ] No breaking changes in public APIs

#### 1.2 Dependency Analysis and Updates
**Duration:** 1 day  
**Assignee:** Developer  

**Steps:**
1. Analyze all third-party dependencies
2. Update to .NET 6.0 compatible versions
3. Test for breaking changes
4. Document any API changes

**Deliverables:**
- Updated dependency matrix
- Breaking changes documentation

---

## Phase 2: Infrastructure Layer Migration (Week 1-2)

### Scope
- Infrastructure project
- Entity Framework Core migration
- Database compatibility validation

### Tasks

#### 2.1 Infrastructure Project Migration
**Duration:** 3 days  
**Assignee:** Senior Developer  

**Steps:**
1. Update `Infrastructure.csproj`:
   ```xml
   <TargetFramework>net6.0</TargetFramework>
   ```

2. Update Entity Framework packages:
   ```xml
   <PackageReference Include="Microsoft.AspNetCore.Identity" Version="6.0.0" />
   <PackageReference Include="Microsoft.AspNetCore.Identity.EntityFrameworkCore" Version="6.0.0" />
   <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="6.0.0" />
   <PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="6.0.0" />
   ```

3. Update DbContext configurations for EF Core 6.0
4. Test database operations

**Validation Criteria:**
- [ ] All database operations work correctly
- [ ] Entity configurations are compatible
- [ ] Migrations can be applied successfully

#### 2.2 Database Migration Validation
**Duration:** 2 days  
**Assignee:** Developer  

**Steps:**
1. Create test database with current schema
2. Apply existing migrations
3. Test data seeding operations
4. Validate query performance

**Deliverables:**
- Database compatibility report
- Performance comparison metrics

---

## Phase 3: Web Applications Migration (Week 2-3)

### Scope
- Web (MVC) project
- WebRazorPages project
- Authentication and authorization updates

### Tasks

#### 3.1 Web MVC Project Migration
**Duration:** 4 days  
**Assignee:** Senior Developer + Developer  

**Steps:**
1. Update `Web.csproj`:
   ```xml
   <TargetFramework>net6.0</TargetFramework>
   ```

2. Remove explicit ASP.NET Core package references:
   ```xml
   <!-- Remove this line -->
   <PackageReference Include="Microsoft.AspNetCore.App" Version="2.1.0" />
   ```

3. Update `Program.cs` for .NET 6.0 hosting model:
   ```csharp
   var builder = WebApplication.CreateBuilder(args);
   
   // Configure services
   builder.Services.AddDbContext<CatalogContext>(options => 
       options.UseInMemoryDatabase("Catalog"));
   
   var app = builder.Build();
   
   // Configure pipeline
   if (app.Environment.IsDevelopment())
   {
       app.UseDeveloperExceptionPage();
   }
   
   app.UseHttpsRedirection();
   app.UseStaticFiles();
   app.UseAuthentication();
   app.UseAuthorization();
   
   app.MapControllerRoute(
       name: "default",
       pattern: "{controller=Catalog}/{action=Index}/{id?}");
   
   app.Run();
   ```

4. Update `Startup.cs` or migrate to Program.cs pattern
5. Replace `IHostingEnvironment` with `IWebHostEnvironment`
6. Remove `SetCompatibilityVersion` calls

**Validation Criteria:**
- [ ] Application starts successfully
- [ ] All controllers and actions work
- [ ] Authentication and authorization function correctly
- [ ] Static files are served properly

#### 3.2 WebRazorPages Project Migration
**Duration:** 3 days  
**Assignee:** Developer  

**Steps:**
1. Follow similar steps as Web MVC project
2. Update Razor Pages specific configurations
3. Test page routing and model binding
4. Validate Razor syntax compatibility

**Validation Criteria:**
- [ ] All Razor pages render correctly
- [ ] Page models function properly
- [ ] Form submissions work as expected

#### 3.3 Authentication System Update
**Duration:** 2 days  
**Assignee:** Senior Developer  

**Steps:**
1. Update Identity configuration for .NET 6.0
2. Test user registration and login
3. Validate cookie authentication
4. Check authorization policies

**Validation Criteria:**
- [ ] User authentication works correctly
- [ ] Existing user accounts remain accessible
- [ ] Authorization policies are enforced

---

## Phase 4: Testing and Deployment (Week 3-4)

### Scope
- Test projects migration
- Integration testing
- Docker configuration updates
- Deployment preparation

### Tasks

#### 4.1 Test Projects Migration
**Duration:** 3 days  
**Assignee:** Developer  

**Steps:**
1. Update all test project files:
   ```xml
   <TargetFramework>net6.0</TargetFramework>
   ```

2. Update testing packages:
   ```xml
   <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.3.2" />
   <PackageReference Include="xunit" Version="2.4.2" />
   <PackageReference Include="xunit.runner.visualstudio" Version="2.4.3" />
   <PackageReference Include="Moq" Version="4.20.69" />
   <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="6.0.0" />
   ```

3. Update test configurations for .NET 6.0
4. Fix any test-specific breaking changes

**Validation Criteria:**
- [ ] All unit tests pass
- [ ] Integration tests execute successfully
- [ ] Functional tests validate end-to-end scenarios

#### 4.2 Docker Configuration Update
**Duration:** 2 days  
**Assignee:** DevOps Engineer/Developer  

**Steps:**
1. Update Dockerfiles:
   ```dockerfile
   FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
   FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
   ```

2. Update docker-compose.yml if needed
3. Test containerized application
4. Validate multi-stage builds

**Validation Criteria:**
- [ ] Docker images build successfully
- [ ] Containerized applications run correctly
- [ ] Docker compose orchestration works

#### 4.3 Performance and Security Testing
**Duration:** 3 days  
**Assignee:** QA Engineer + Developer  

**Steps:**
1. Execute performance benchmarks
2. Compare with .NET Core 2.1 baseline
3. Run security scans
4. Validate HTTPS and authentication security

**Validation Criteria:**
- [ ] Performance meets or exceeds baseline
- [ ] No security regressions identified
- [ ] Memory usage is optimized

#### 4.4 Deployment Preparation
**Duration:** 2 days  
**Assignee:** DevOps Engineer  

**Steps:**
1. Update CI/CD pipelines for .NET 6.0
2. Prepare deployment scripts
3. Update environment configurations
4. Plan rollback procedures

**Deliverables:**
- Updated deployment documentation
- Rollback procedures
- Environment configuration guides

---

## Testing Strategy

### Unit Testing
- **Scope:** All business logic and services
- **Tools:** xUnit, Moq, FluentAssertions
- **Coverage Target:** Maintain current coverage levels (>80%)
- **Execution:** Automated in CI/CD pipeline

### Integration Testing
- **Scope:** Database operations, API endpoints
- **Tools:** ASP.NET Core Test Host, Entity Framework In-Memory
- **Focus Areas:** Data access, authentication, authorization
- **Execution:** Automated and manual validation

### Functional Testing
- **Scope:** End-to-end user scenarios
- **Tools:** Selenium WebDriver, ASP.NET Core MVC Testing
- **Scenarios:** User registration, product catalog, shopping cart
- **Execution:** Automated test suite

### Performance Testing
- **Metrics:** Response time, throughput, memory usage
- **Tools:** NBomber, Application Insights
- **Baseline:** Current .NET Core 2.1 performance
- **Target:** 10-20% improvement in key metrics

---

## Risk Management

### High-Risk Areas
1. **Entity Framework Core Changes**
   - **Mitigation:** Thorough database testing, migration validation
   - **Contingency:** Maintain EF Core 2.1 compatibility layer if needed

2. **Authentication System Changes**
   - **Mitigation:** Comprehensive authentication testing
   - **Contingency:** Gradual rollout with user session validation

3. **Third-Party Dependencies**
   - **Mitigation:** Early compatibility testing, vendor communication
   - **Contingency:** Alternative package evaluation

### Medium-Risk Areas
1. **Docker Configuration**
   - **Mitigation:** Parallel environment testing
   - **Contingency:** Maintain separate .NET 6.0 container images

2. **CI/CD Pipeline Changes**
   - **Mitigation:** Pipeline testing in staging environment
   - **Contingency:** Manual deployment procedures

---

## Quality Gates

### Phase Completion Criteria
Each phase must meet the following criteria before proceeding:

#### Code Quality
- [ ] All code compiles without warnings
- [ ] Code analysis passes with no critical issues
- [ ] Unit test coverage maintained or improved

#### Functionality
- [ ] All existing features work as expected
- [ ] No regression in user experience
- [ ] Performance benchmarks met

#### Security
- [ ] Security scan passes
- [ ] Authentication and authorization validated
- [ ] No new security vulnerabilities introduced

---

## Rollback Plan

### Rollback Triggers
- Critical functionality failure
- Significant performance degradation (>20%)
- Security vulnerabilities introduced
- Unresolvable compatibility issues

### Rollback Procedure
1. **Immediate:** Switch traffic back to .NET Core 2.1 version
2. **Code:** Revert to last known good commit
3. **Database:** Restore from backup if schema changes made
4. **Infrastructure:** Redeploy previous container images
5. **Communication:** Notify stakeholders of rollback

### Recovery Time Objective (RTO)
- **Target:** 30 minutes for production rollback
- **Maximum:** 2 hours for complete environment restoration

---

## Communication Plan

### Stakeholders
- Development Team
- QA Team
- DevOps Team
- Product Owner
- System Administrators

### Communication Schedule
- **Weekly:** Progress updates during migration
- **Phase Completion:** Detailed phase reports
- **Issues:** Immediate notification for blockers
- **Completion:** Final migration report and lessons learned

### Communication Channels
- **Regular Updates:** Team meetings, email reports
- **Issues:** Slack/Teams channels, issue tracking system
- **Documentation:** Confluence/SharePoint, Git repository

---

## Success Metrics

### Technical Metrics
- **Compilation:** 100% successful builds
- **Tests:** 100% test pass rate
- **Performance:** 10-20% improvement in response times
- **Memory:** Reduced memory footprint
- **Security:** No new vulnerabilities

### Business Metrics
- **Downtime:** Zero unplanned downtime during migration
- **User Experience:** No degradation in user satisfaction
- **Development Velocity:** Maintained or improved development speed
- **Maintenance:** Reduced maintenance overhead

---

## Post-Migration Activities

### Immediate (Week 4)
- [ ] Performance monitoring and optimization
- [ ] User feedback collection and analysis
- [ ] Documentation updates
- [ ] Team retrospective and lessons learned

### Short-term (Month 1)
- [ ] Leverage .NET 6.0 specific features
- [ ] Optimize for new runtime capabilities
- [ ] Update development practices and guidelines
- [ ] Plan for future .NET upgrades

### Long-term (Months 2-3)
- [ ] Evaluate new .NET 6.0 features for implementation
- [ ] Performance optimization based on production metrics
- [ ] Security enhancements using new framework features
- [ ] Developer training on .NET 6.0 best practices

---

## Appendices

### Appendix A: Detailed Task Breakdown
[Detailed work breakdown structure with specific tasks, dependencies, and time estimates]

### Appendix B: Environment Configuration
[Specific configuration changes required for each environment]

### Appendix C: Testing Scenarios
[Comprehensive list of test scenarios and acceptance criteria]

### Appendix D: Troubleshooting Guide
[Common issues and their resolutions during migration]

---

## References

**Sources Used for This Plan:**
- Microsoft .NET 6.0 Migration Documentation: https://docs.microsoft.com/en-us/aspnet/core/migration/50-to-60
- ASP.NET Core 6.0 What's New: https://docs.microsoft.com/en-us/aspnet/core/release-notes/aspnetcore-6.0
- Entity Framework Core 6.0 Documentation: https://docs.microsoft.com/en-us/ef/core/what-is-new/ef-core-6.0/
- Project source code analysis from `/workspace/eShopOnWeb/`
- Industry best practices for .NET migration projects

---

**Document Prepared By:** OpenHands AI Assistant  
**Review Status:** Draft - Requires Technical Review and Approval  
**Approval Required From:** Technical Lead, Project Manager, DevOps Lead  
**Next Review Date:** Upon stakeholder review completion

