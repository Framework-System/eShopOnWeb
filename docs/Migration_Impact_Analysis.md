# eShopOnWeb Migration Impact Analysis
## From .NET Core 2.1 to .NET 6.0

**Document Version:** 1.0  
**Date:** July 15, 2025  
**Project:** eShopOnWeb Reference Application  

---

## Executive Summary

This document provides a comprehensive analysis of the impact of migrating the eShopOnWeb project from .NET Core 2.1 to .NET 6.0. The analysis covers all dependencies, breaking changes, and compatibility issues that need to be addressed during the migration process.

**Current State:** .NET Core 2.1 (ASP.NET Core 2.1)  
**Target State:** .NET 6.0  
**Migration Complexity:** Medium to High  

---

## Project Structure Analysis

### Current Project Targets
- **Web Projects:** `netcoreapp2.1`
  - `src/Web/Web.csproj` (MVC Application)
  - `src/WebRazorPages/WebRazorPages.csproj` (Razor Pages Application)
  - All test projects (`tests/UnitTests`, `tests/IntegrationTests`, `tests/FunctionalTests`)

- **Class Libraries:** `netstandard2.0`
  - `src/ApplicationCore/ApplicationCore.csproj` (Domain Layer)
  - `src/Infrastructure/Infrastructure.csproj` (Data Access Layer)

### Target Framework Changes Required
- **Web Projects:** `netcoreapp2.1` → `net6.0`
- **Class Libraries:** `netstandard2.0` → `net6.0` (recommended) or keep `netstandard2.0` (compatible)

---

## Dependency Analysis

### Core Framework Dependencies

#### Microsoft.AspNetCore.App (Current: 2.1.0)
**Impact:** HIGH  
**Action Required:** Remove explicit package reference  
**Reason:** In .NET 6.0, ASP.NET Core is included in the framework and doesn't require explicit package references.

**Current Usage:**
```xml
<PackageReference Include="Microsoft.AspNetCore.App" Version="2.1.0" />
```

**Migration Action:**
- Remove the explicit package reference
- Functionality is included in .NET 6.0 framework

#### Entity Framework Core Dependencies (Current: 2.1.0)
**Impact:** HIGH  
**Packages Affected:**
- `Microsoft.EntityFrameworkCore.SqlServer` (2.1.0 → 6.0.x)
- `Microsoft.EntityFrameworkCore.Tools` (2.1.0 → 6.0.x)
- `Microsoft.AspNetCore.Identity.EntityFrameworkCore` (2.1.0 → 6.0.x)

**Breaking Changes:**
- Database provider API changes
- Query translation improvements may affect existing queries
- Migrations may require updates
- Connection string handling changes

#### ASP.NET Core Identity (Current: 2.1.0)
**Impact:** MEDIUM  
**Package:** `Microsoft.AspNetCore.Identity` (2.1.0 → included in framework)

**Breaking Changes:**
- Identity UI changes
- Cookie authentication configuration changes
- Password hashing algorithm updates (backward compatible)

### Third-Party Dependencies

#### Dapper (Current: 1.50.5)
**Impact:** LOW  
**Current Version:** 1.50.5  
**Target Version:** 2.0.x (latest stable)  
**Compatibility:** Good - minimal breaking changes expected

#### Ardalis.GuardClauses (Current: 1.2.3)
**Impact:** LOW  
**Current Version:** 1.2.3  
**Target Version:** 4.x.x (latest stable)  
**Compatibility:** Good - API remains largely compatible

#### Testing Dependencies
**Impact:** MEDIUM  
**Packages Affected:**
- `Microsoft.NET.Test.Sdk` (15.8.0-preview → 17.x.x)
- `xunit` (2.3.1 → 2.4.x)
- `xunit.runner.visualstudio` (2.3.1 → 2.4.x)
- `Moq` (4.8.2 → 4.20.x)
- `Microsoft.AspNetCore.Mvc.Testing` (2.1.0 → 6.0.x)

---

## Code Impact Analysis

### Startup.cs Changes
**Impact:** HIGH  

**Current Pattern (ASP.NET Core 2.1):**
```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddMvc()
        .SetCompatibilityVersion(AspNetCore.Mvc.CompatibilityVersion.Version_2_1);
}

public void Configure(IApplicationBuilder app, IHostingEnvironment env)
{
    // Configuration code
}
```

**Required Changes for .NET 6.0:**
- Replace `IHostingEnvironment` with `IWebHostEnvironment`
- Remove `SetCompatibilityVersion` calls
- Update service registration patterns
- Consider migrating to minimal hosting model (optional)

### Program.cs Changes
**Impact:** HIGH  

**Current Pattern:**
```csharp
public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
    WebHost.CreateDefaultBuilder(args)
        .UseStartup<Startup>();
```

**Required Changes:**
- Migrate to new hosting model with `Host.CreateDefaultBuilder`
- Update service configuration approach
- Consider adopting minimal APIs pattern (optional)

### Entity Framework Core Changes
**Impact:** MEDIUM to HIGH  

**Potential Issues:**
- Query translation changes may affect complex LINQ queries
- Migration files may need updates
- Connection string configuration changes
- DbContext configuration updates required

### Authentication & Authorization
**Impact:** MEDIUM  

**Areas Affected:**
- Cookie authentication configuration
- Identity configuration
- Authorization policy setup

---

## Configuration Changes

### appsettings.json
**Impact:** LOW  
**Changes Required:** Minimal - mostly compatible

### launchSettings.json
**Impact:** LOW  
**Changes Required:** May need updates for new development server features

### Docker Configuration
**Impact:** MEDIUM  
**Files Affected:**
- `src/Web/Dockerfile`
- `src/WebRazorPages/Dockerfile`
- `docker-compose.yml`

**Required Changes:**
- Update base images from `mcr.microsoft.com/dotnet/core/aspnet:2.1` to `mcr.microsoft.com/dotnet/aspnet:6.0`
- Update SDK images from `mcr.microsoft.com/dotnet/core/sdk:2.1` to `mcr.microsoft.com/dotnet/sdk:6.0`

---

## Performance Impact

### Positive Impacts
- **Improved Performance:** .NET 6.0 offers significant performance improvements
- **Better Memory Management:** Reduced memory allocation and improved GC
- **Enhanced HTTP/2 Support:** Better performance for modern web scenarios

### Potential Concerns
- **Initial Performance Testing Required:** Validate performance after migration
- **Memory Usage Patterns:** May change due to framework improvements

---

## Security Considerations

### Enhanced Security Features
- **Improved HTTPS Handling:** Better default HTTPS configuration
- **Enhanced Authentication:** Updated authentication mechanisms
- **Security Headers:** Improved default security header handling

### Migration Considerations
- **Password Hashing:** Existing passwords remain compatible
- **Cookie Security:** Enhanced cookie security options
- **CORS Configuration:** May require updates

---

## Breaking Changes Summary

### High Priority Breaking Changes
1. **Framework Package References:** Remove explicit ASP.NET Core package references
2. **Hosting Model:** Update Program.cs and Startup.cs patterns
3. **Environment Interface:** Replace `IHostingEnvironment` with `IWebHostEnvironment`
4. **Entity Framework:** Update EF Core packages and potentially migration files

### Medium Priority Breaking Changes
1. **MVC Compatibility Version:** Remove `SetCompatibilityVersion` calls
2. **Testing Framework:** Update test SDK and runner versions
3. **Docker Images:** Update base images in Dockerfiles

### Low Priority Breaking Changes
1. **Third-party Packages:** Update to compatible versions
2. **Configuration Patterns:** Minor updates to configuration approaches

---

## Compatibility Matrix

| Component | .NET Core 2.1 Version | .NET 6.0 Version | Compatibility | Migration Effort |
|-----------|----------------------|------------------|---------------|------------------|
| ASP.NET Core | 2.1.0 | Built-in | High | Medium |
| Entity Framework Core | 2.1.0 | 6.0.x | High | Medium |
| ASP.NET Core Identity | 2.1.0 | Built-in | High | Low |
| Dapper | 1.50.5 | 2.0.x | High | Low |
| xUnit | 2.3.1 | 2.4.x | High | Low |
| Moq | 4.8.2 | 4.20.x | High | Low |

---

## Recommendations

### Immediate Actions
1. **Create Migration Branch:** Establish dedicated branch for migration work
2. **Update Development Environment:** Install .NET 6.0 SDK
3. **Backup Current State:** Ensure current application is fully backed up
4. **Review Dependencies:** Audit all NuGet packages for .NET 6.0 compatibility

### Migration Strategy
1. **Incremental Approach:** Migrate one project at a time
2. **Testing First:** Update test projects first to validate migration approach
3. **Infrastructure Layer:** Migrate data access layer before presentation layer
4. **Validation:** Comprehensive testing at each migration step

---

## References

**Sources Used for This Analysis:**
- Project source code analysis from `/workspace/eShopOnWeb/`
- Microsoft .NET 6.0 Migration Guide: https://docs.microsoft.com/en-us/aspnet/core/migration/50-to-60
- ASP.NET Core 2.1 to 6.0 Breaking Changes: https://docs.microsoft.com/en-us/dotnet/core/compatibility/aspnet-core
- Entity Framework Core 6.0 Breaking Changes: https://docs.microsoft.com/en-us/ef/core/what-is-new/ef-core-6.0/breaking-changes
- NuGet Package Compatibility Information from respective package documentation

---

**Document Prepared By:** OpenHands AI Assistant  
**Review Status:** Draft - Requires Technical Review  
**Next Review Date:** Upon completion of migration planning phase
