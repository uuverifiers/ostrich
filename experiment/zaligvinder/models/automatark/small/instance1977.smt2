(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ( xmlns:.*=[",'].*[",'])|( xmlns=[",'].*[",'])
(assert (str.in_re X (re.union (re.++ (str.to_re " xmlns:") (re.* re.allchar) (str.to_re "=") (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'")) (re.* re.allchar) (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'"))) (re.++ (str.to_re "\u{0a} xmlns=") (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'")) (re.* re.allchar) (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'"))))))
; ^(GIR|[A-Z]\d[A-Z\d]??|[A-Z]{2}\d[A-Z\d]??)[ ]??(\d[A-Z]{2})$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "GIR") (re.++ (re.range "A" "Z") (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9")))) (re.++ ((_ re.loop 2 2) (re.range "A" "Z")) (re.range "0" "9") (re.opt (re.union (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (str.to_re " ")) (str.to_re "\u{0a}") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z"))))))
; ^\d{2}[0-1][0-9][0-3][0-9]-{0,1}\d{2}-{0,1}\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "1") (re.range "0" "9") (re.range "0" "3") (re.range "0" "9") (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; www\x2Edotcomtoolbar\x2Ecom\d+DesktopAddressIDENTIFY
(assert (str.in_re X (re.++ (str.to_re "www.dotcomtoolbar.com") (re.+ (re.range "0" "9")) (str.to_re "DesktopAddressIDENTIFY\u{0a}"))))
(check-sat)
