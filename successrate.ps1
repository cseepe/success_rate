﻿$log = docker logs storagenode 2>&1

"========== AUDIT ============="

$auditsSuccess = ($log | sls GET_AUDIT | sls downloaded).Count
"Successful:`t`t" + $auditsSuccess

$auditsFailed = ($log | sls GET_AUDIT | sls failed | sls open -NotMatch).Count
"Recoverable failed:`t" + $auditsFailed

$auditsFailedCritical = ($log | sls GET_AUDIT | sls failed | sls open).Count
"Unrecoverable failed:`t" + $auditsFailedCritical

if (($auditsSuccess + $auditsFailed + $auditsFailedCritical) -ge 1) {
    $auditsRateMin = $auditsSuccess / ($auditsSuccess + $auditsFailed + $auditsFailedCritical) * 100
} else {
    $auditsRateMin = 0.00
}
"Success Min:`t`t" + $auditsRateMin + "%"

if (($auditsSuccess + $auditsFailedCritical) -ge 1) {
    $auditsRateMax = $auditsSuccess / ($auditsSuccess + $auditsFailedCritical) * 100
} else {
    $auditsRateMax = 0.00
}
"Success Max:`t`t" + $auditsRateMax + "%"

"========== DOWNLOAD =========="

$dl_success = ($log | sls '"GET"' | sls downloaded).Count
"Successful:`t`t" + $dl_success

$dl_failed = ($log | sls '"GET"' | sls failed).Count
"Failed:`t`t`t" + $dl_failed

if (($dl_success + $dl_failed) -ge 1) {
    $dl_ratio = $dl_success / ($dl_success + $dl_failed) * 100
} else {
    $dl_ratio = 0.00
}
"Success Rate:`t`t" + $dl_ratio

"========== UPLOAD ============"

$put_success = ($log | sls '"PUT"' | sls uploaded).Count
"Successful:`t`t" + $put_success

$put_rejected = ($log | sls '"PUT"' | sls rejected).Count
"Rejected:`t`t" + $put_rejected

$put_failed = ($log | sls '"PUT"' | sls failed).Count
"Failed:`t`t`t" + $put_failed

if (($put_success + $put_rejected) -ge 1) {
    $put_accept_ratio = $put_success / ($put_success + $put_rejected) * 100
} else {
    $put_accept_ratio = 0.00
}
"Acceptance Rate:`t" + $put_accept_ratio

if (($put_success + $put_failed) -ge 1) {
    $put_ratio = $put_success / ($put_success + $put_failed) * 100
} else {
    $put_ratio = 0.00
}
"Success Rate:`t`t" + $put_ratio

"========== REPAIR DOWNLOAD ==="

$get_repair_success = ($log | sls GET_REPAIR | sls downloaded).Count
"Successful:`t`t" + $get_repair_success

$get_repair_failed = ($log | sls GET_REPAIR | sls failed).Count
"Failed:`t`t`t" + $get_repair_failed

if (($get_repair_success + $get_repair_failed) -ge 1) {
    $get_repair_ratio = $get_repair_success / ($get_repair_success + $get_repair_failed) * 100
} else {
    $get_repair_ratio = 0.00
}
"Success Rate:`t`t" + $get_repair_ratio

"========== REPAIR UPLOAD ====="

$put_repair_success = ($log | sls PUT_REPAIR | sls uploaded).Count
"Successful:`t`t" + $get_repair_success

$put_repair_failed = ($log | sls PUT_REPAIR | sls failed).Count
"Failed:`t`t`t" + $put_repair_failed

if (($put_repair_success + $put_repair_failed) -ge 1) {
    $put_repair_ratio = $put_repair_success / ($put_repair_success + $put_repair_failed) * 100
} else {
    $put_repair_ratio = 0.00
}
"Success Rate:`t`t" + $put_repair_ratio