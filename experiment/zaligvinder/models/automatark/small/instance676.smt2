(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0]\d|[1][0-2]\/([0-2]\d|[3][0-1])\/([2][0]\d{2})\s([0-1]\d|[2][0-3])\:[0-5]\d\:[0-5]\d)?\s(AM|am|aM|Am|PM|pm|pM|Pm)
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2") (str.to_re "/") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (str.to_re ":") (re.range "0" "5") (re.range "0" "9") (str.to_re "20") ((_ re.loop 2 2) (re.range "0" "9"))))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (str.to_re "AM") (str.to_re "am") (str.to_re "aM") (str.to_re "Am") (str.to_re "PM") (str.to_re "pm") (str.to_re "pM") (str.to_re "Pm")) (str.to_re "\u{0a}"))))
; upgrade\x2Eqsrch\x2Einfo.*report.*Host\x3A.*Host\x3Akwd-i%3fUser-Agent\x3Awww\u{2e}proventactics\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "upgrade.qsrch.info") (re.* re.allchar) (str.to_re "report") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "Host:kwd-i%3fUser-Agent:www.proventactics.com\u{0a}")))))
; ^[A-Z]{3}\d{8}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "A" "Z")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; XPPreUser-Agent\x3ARemoteYOURsqlStarLoggerclvompycem\u{2f}cen\.vcn
(assert (not (str.in_re X (str.to_re "XPPreUser-Agent:RemoteYOURsqlStarLoggerclvompycem/cen.vcn\u{0a}"))))
(check-sat)