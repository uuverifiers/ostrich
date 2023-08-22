(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0+[1-9]|[1-9])[0-9]*$
(assert (str.in_re X (re.++ (re.union (re.++ (re.+ (str.to_re "0")) (re.range "1" "9")) (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; [^A-Za-z0-9_@\.]|@{2,}|\.{5,}
(assert (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (str.to_re "@")) (re.* (str.to_re "@"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (str.to_re ".")) (re.* (str.to_re "."))) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "@") (str.to_re "."))))
; Host\x3A\d+Host\x3A.*communitytipHost\x3AGirafaClient
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Host:") (re.* re.allchar) (str.to_re "communitytipHost:GirafaClient\u{13}\u{0a}")))))
; \x7D\x7BSysuptime\x3A\d+\x2Fcommunicatortb
(assert (not (str.in_re X (re.++ (str.to_re "}{Sysuptime:") (re.+ (re.range "0" "9")) (str.to_re "/communicatortb\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
