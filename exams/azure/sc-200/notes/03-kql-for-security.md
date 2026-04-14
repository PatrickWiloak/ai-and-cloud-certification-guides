# 03 - KQL for Security

## What Is KQL?

Kusto Query Language (KQL) is the read-only query language used by Azure Data Explorer, Log Analytics, Microsoft Sentinel, Microsoft Defender XDR (advanced hunting), Application Insights, Microsoft 365 Compliance, and many other Microsoft data services. For SC-200, you must read and write KQL fluently.

KQL is pipeline-based. A query starts with a table or tabular expression, and each `|` operator transforms the result.

## Query Anatomy

```kql
TableName
| where TimeGenerated > ago(1d)
| where AccountName has "admin"
| project TimeGenerated, Computer, AccountName, EventID
| summarize Count = count() by AccountName
| sort by Count desc
| take 10
```

This pattern (filter -> project -> aggregate -> sort -> limit) is the bread and butter of detection and hunting queries.

## Essential Operators

### Filtering
```kql
| where TimeGenerated > ago(7d)
| where Computer == "DC01"
| where AccountName has_any ("admin", "svc-")
| where EventID in (4624, 4625)
| where ProcessCommandLine matches regex @"\\powershell\.exe.*-enc"
| where isnotempty(IPAddress)
```

Operators ranked by performance (fastest to slowest):
1. `==`, `!=` (exact)
2. `has`, `has_any`, `has_all` (whole-word, indexed)
3. `startswith`, `endswith`
4. `contains` (substring, slow)
5. `matches regex` (slowest)

Always prefer `has` over `contains` when matching whole tokens - dramatically faster on large datasets.

### Selection
```kql
| project TimeGenerated, Computer, AccountName, EventID
| project-rename Account = AccountName, Host = Computer
| project-away SourceSystem, Type
| project-keep Time*, Computer, Account*
```

### Calculated columns
```kql
| extend Hour = bin(TimeGenerated, 1h)
| extend IsAdmin = AccountName has "admin"
| extend Geo = geo_info_from_ip_address(IPAddress)
```

### Aggregation
```kql
| summarize Count = count() by AccountName
| summarize FailedCount = countif(EventID == 4625), SuccessCount = countif(EventID == 4624) by AccountName
| summarize make_set(IPAddress) by AccountName
| summarize make_list(Activity, 100) by Computer
| summarize arg_max(TimeGenerated, *) by Computer  // latest row per computer
```

### Time aggregations
```kql
| summarize Count = count() by bin(TimeGenerated, 5m)
| make-series Count = count() default = 0 on TimeGenerated from ago(7d) to now() step 1h by Computer
```

### Joins
```kql
SigninLogs
| where ResultType != 0
| join kind=inner (
    SigninLogs
    | where ResultType == 0
) on UserPrincipalName, $left.IPAddress == $right.IPAddress
```

Join kinds:
- `inner` - rows with matches in both (default in some places)
- `innerunique` - inner with deduplication on left
- `leftouter` - all left + matched right
- `rightouter` - all right + matched left
- `fullouter` - all rows from both
- `leftanti` - left rows with NO match in right (powerful for "not seen elsewhere" patterns)
- `leftsemi` - left rows that have a match (returns only left columns)

### Union
```kql
union SigninLogs, AADNonInteractiveUserSignInLogs
| where UserPrincipalName == "user@contoso.com"
```

### Parsing
```kql
| parse ProcessCommandLine with * "-File " ScriptPath:string
| parse_json(AdditionalFields)
| extend Parsed = parse_csv(MyField)
```

### Arrays and dynamics
```kql
| mv-expand Tactics
| mv-apply step = Steps to typeof(dynamic) on (
    where step.Name == "execute"
    | project step.Result
)
| extend Hashes = bag_unpack(FileHashes)
```

### Time helpers
```kql
ago(7d), now(), bin(TimeGenerated, 1h)
startofday(TimeGenerated), startofweek, startofmonth
datetime_diff('day', endTime, startTime)
format_datetime(TimeGenerated, 'yyyy-MM-dd HH:mm')
```

### Useful functions
```kql
iff(condition, ifTrue, ifFalse)
case(cond1, val1, cond2, val2, default)
toscalar(query) // returns single value for use in let
strcat(a, b, c)
split(str, delim)
tolower(), toupper(), trim()
geo_info_from_ip_address(ip)
ipv4_is_private(ip)
hash_sha256(input)
```

## let Statements

Variables for reuse:
```kql
let lookback = 7d;
let suspiciousIPs = dynamic(["1.2.3.4", "5.6.7.8"]);
let badProcesses = DeviceProcessEvents
    | where Timestamp > ago(lookback)
    | where ProcessCommandLine has_any (suspiciousIPs);
let badAccounts = badProcesses | distinct AccountName;
DeviceLogonEvents
| where Timestamp > ago(lookback)
| where AccountName in (badAccounts)
```

## Common Detection Patterns

### Failed logon brute force
```kql
SigninLogs
| where ResultType !in ("0", "50125", "50140")
| summarize FailedAttempts = count(), distinct_ips = dcount(IPAddress) by UserPrincipalName, bin(TimeGenerated, 1h)
| where FailedAttempts > 20
```

### Impossible travel
```kql
SigninLogs
| where ResultType == 0
| extend Geo = strcat(LocationDetails.countryOrRegion, "-", LocationDetails.city)
| order by UserPrincipalName, TimeGenerated asc
| serialize
| extend PrevGeo = prev(Geo), PrevTime = prev(TimeGenerated), PrevUser = prev(UserPrincipalName)
| where UserPrincipalName == PrevUser and Geo != PrevGeo
| extend MinutesBetween = datetime_diff('minute', TimeGenerated, PrevTime)
| where MinutesBetween < 60
```

### Beaconing detection
```kql
DeviceNetworkEvents
| where Timestamp > ago(7d)
| make-series Conn = count() default = 0 on Timestamp from ago(7d) to now() step 1h by DeviceName, RemoteUrl
| extend (anomalies, score, baseline) = series_decompose_anomalies(Conn, 1.5)
| mv-expand anomalies, score, baseline, Timestamp
| where anomalies != 0
```

### Process tree
```kql
DeviceProcessEvents
| where ProcessId == 1234 and DeviceName == "WS-FINANCE"
| join kind=inner (
    DeviceProcessEvents
    | where InitiatingProcessId == 1234
) on DeviceName
| project Timestamp, ProcessCommandLine = ProcessCommandLine1, ParentCommandLine = ProcessCommandLine
```

### Mass file download (insider risk)
```kql
OfficeActivity
| where Operation == "FileDownloaded"
| summarize Files = count() by UserId, bin(TimeGenerated, 1h)
| where Files > 100
```

## Defender XDR Advanced Hunting Schema

Key tables:

### Device tables
- `DeviceInfo` - inventory
- `DeviceProcessEvents` - process creation
- `DeviceNetworkEvents` - network connections, listening ports
- `DeviceFileEvents` - file create, modify, rename, delete
- `DeviceRegistryEvents` - registry actions
- `DeviceLogonEvents` - successful and failed logons
- `DeviceImageLoadEvents` - DLL loads
- `DeviceEvents` - misc behavioral signals

### Email tables
- `EmailEvents` - email metadata (subject, sender, recipient, verdict)
- `EmailAttachmentInfo` - attachment details
- `EmailUrlInfo` - URLs in emails
- `UrlClickEvents` - Safe Links click telemetry

### Identity tables
- `IdentityLogonEvents` - on-prem AD logons (MDI)
- `IdentityQueryEvents` - AD queries (LDAP, SAMR)
- `IdentityDirectoryEvents` - AD changes
- `IdentityInfo` - identity inventory

### Cloud apps tables
- `CloudAppEvents` - MDA monitored app activity

### Alert tables
- `AlertInfo` - alert metadata
- `AlertEvidence` - per-entity evidence rows linked to alerts

## Performance Tips

1. **Filter early**: `where TimeGenerated > ago(1d)` first, before joins
2. **Project early**: drop unneeded columns to reduce join cost
3. **Use `has` not `contains`** when matching whole tokens
4. **Avoid `*` in `summarize arg_max(*)` on huge tables** - select specific columns
5. **Use `materialize()`** when reusing a `let` result multiple times
6. **Use `hint.shufflekey` and `hint.strategy=broadcast`** on large joins
7. **Use `take_any()` to dedupe** on key without expensive aggregation
8. **Avoid regex when string operators suffice**

## Common Exam Pitfalls

- Confusing `has` (whole word) with `contains` (substring); a question may give two queries differing only by this
- Forgetting that `==` is case-sensitive but `=~` is case-insensitive
- Using `join` when `lookup` or `union` would be better
- Forgetting `serialize` before `prev()` / `next()` for ordered comparisons
- NRT analytics rules cannot use `join` or aggregation operators
- Confusing `let` with `set` - KQL uses `let`
- Forgetting to map entities so KQL columns become Sentinel/XDR entities for response actions

## Practice Resources

- KQL Detective Agency: https://detective.kusto.io/
- KQL learning path on Microsoft Learn
- Rod Trent's "Must Learn KQL" book and free GitHub series
- Sentinel hunting GitHub: github.com/Azure/Azure-Sentinel/tree/master/Hunting Queries
- Defender XDR hunting samples: github.com/microsoft/Microsoft-365-Defender-Hunting-Queries
