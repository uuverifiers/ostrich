(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; From\x3A\w+SoftActivity\d+
(assert (not (str.in_re X (re.++ (str.to_re "From:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "SoftActivity\u{13}") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\/setup.cgi.*?TimeToLive=[^&]*?(%60|\u{60})/iU
(assert (not (str.in_re X (re.++ (str.to_re "//setup") re.allchar (str.to_re "cgi") (re.* re.allchar) (str.to_re "TimeToLive=") (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "%60") (str.to_re "`")) (str.to_re "/iU\u{0a}")))))
; ^\d*((\.\d+)?)*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.* (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; ^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$
(assert (not (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
