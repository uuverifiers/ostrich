(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; dll\x3F\w+updates\w+Host\u{3a}SoftwareHost\x3Ajoke
(assert (str.in_re X (re.++ (str.to_re "dll?") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "updates") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:SoftwareHost:joke\u{0a}"))))
; Host\x3A\x2Fta\x2FNEWS\x2Fyayad\x2Ecom
(assert (str.in_re X (str.to_re "Host:/ta/NEWS/yayad.com\u{13}\u{0a}")))
; ^\d*(\.\d*)$
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (str.to_re "\u{0a}.") (re.* (re.range "0" "9")))))
; com\x2Findex\.php\?tpid=.*pop\x2Epopuptoast\x2Ecom.*Host\x3A
(assert (str.in_re X (re.++ (str.to_re "com/index.php?tpid=") (re.* re.allchar) (str.to_re "pop.popuptoast.com") (re.* re.allchar) (str.to_re "Host:\u{0a}"))))
; /^die\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/die|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
(check-sat)
