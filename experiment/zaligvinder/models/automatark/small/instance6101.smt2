(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; on\dName=Your\+Host\+is\x3AcdpViewHost\x3AUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "on") (re.range "0" "9") (str.to_re "Name=Your+Host+is:cdpViewHost:User-Agent:\u{0a}"))))
; Test\d+DesktopAddressIDENTIFY666User-Agent\x3A\x5BStatic
(assert (str.in_re X (re.++ (str.to_re "Test") (re.+ (re.range "0" "9")) (str.to_re "DesktopAddressIDENTIFY666User-Agent:[Static\u{0a}"))))
; ^[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}$
(assert (str.in_re X (re.++ ((_ re.loop 8 8) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "-") ((_ re.loop 12 12) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; (^\d*\.?\d*[0-9]+\d*$)|(^[0-9]+\d*\.\d*$)
(assert (str.in_re X (re.union (re.++ (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.* (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") (re.+ (re.range "0" "9")) (re.* (re.range "0" "9")) (str.to_re ".") (re.* (re.range "0" "9"))))))
(check-sat)
