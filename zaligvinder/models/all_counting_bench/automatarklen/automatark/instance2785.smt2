(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-3][0-9][0-1]\d{3}-\d{4}?
(assert (str.in_re X (re.++ (re.range "0" "3") (re.range "0" "9") (re.range "0" "1") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[a-zA-Z0-9][a-zA-Z0-9_]{2,29}$
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) ((_ re.loop 2 29) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; ((https?|ftp|gopher|telnet|file|notes|ms-help):((//)|(\\\\))+[\w\d:#@%/;$()~_\+-=\\\.&]*)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (str.to_re "http") (re.opt (str.to_re "s"))) (str.to_re "ftp") (str.to_re "gopher") (str.to_re "telnet") (str.to_re "file") (str.to_re "notes") (str.to_re "ms-help")) (str.to_re ":") (re.+ (re.union (str.to_re "//") (str.to_re "\u{5c}\u{5c}"))) (re.* (re.union (re.range "0" "9") (str.to_re ":") (str.to_re "#") (str.to_re "@") (str.to_re "%") (str.to_re "/") (str.to_re ";") (str.to_re "$") (str.to_re "(") (str.to_re ")") (str.to_re "~") (str.to_re "_") (re.range "+" "=") (str.to_re "\u{5c}") (str.to_re ".") (str.to_re "&") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; /[a-z0-9]{32}\.jar/
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".jar/\u{0a}")))))
; GmbH\s+Host\x3AHost\x3AMonitoringGoogle
(assert (str.in_re X (re.++ (str.to_re "GmbH") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:MonitoringGoogle\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
