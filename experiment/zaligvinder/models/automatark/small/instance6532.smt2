(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^[^\u{00}][^\u{00}\u{01}]+$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.comp (str.to_re "\u{00}")) (re.+ (re.union (str.to_re "\u{00}") (str.to_re "\u{01}"))) (str.to_re "/\u{0a}")))))
; urn:[a-z0-9]{1}[a-z0-9\-]{1,31}:[a-z0-9_,:=@;!'%/#\(\)\+\-\.\$\*\?]+
(assert (str.in_re X (re.++ (str.to_re "urn:") ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 1 31) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-"))) (str.to_re ":") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ",") (str.to_re ":") (str.to_re "=") (str.to_re "@") (str.to_re ";") (str.to_re "!") (str.to_re "'") (str.to_re "%") (str.to_re "/") (str.to_re "#") (str.to_re "(") (str.to_re ")") (str.to_re "+") (str.to_re "-") (str.to_re ".") (str.to_re "$") (str.to_re "*") (str.to_re "?"))) (str.to_re "\u{0a}"))))
; Toolbarwww\x2Eonlinecasinoextra\x2Ecom
(assert (str.in_re X (str.to_re "Toolbarwww.onlinecasinoextra.com\u{0a}")))
; Host\x3A\d+Litequick\x2Eqsrch\x2EcomaboutHost\x3AComputer\x7D\x7BSysuptime\x3A
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Litequick.qsrch.comaboutHost:Computer}{Sysuptime:\u{0a}"))))
(check-sat)
