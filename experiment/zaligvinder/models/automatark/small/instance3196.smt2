(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2FGR.*Report.*Host\x3APopup\.cfg
(assert (str.in_re X (re.++ (str.to_re "/GR") (re.* re.allchar) (str.to_re "Report") (re.* re.allchar) (str.to_re "Host:Popup.cfg\u{0a}"))))
; ^(((((0[1-9])|(1\d)|(2[0-8]))-((0[1-9])|(1[0-2])))|((31-((0[13578])|(1[02])))|((29|30)-((0[1,3-9])|(1[0-2])))))-((20[0-9][0-9]))|(29-02-20(([02468][048])|([13579][26]))))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8"))) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2")))) (re.++ (str.to_re "31-") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2"))))) (re.++ (re.union (str.to_re "29") (str.to_re "30")) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re ",") (re.range "3" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))))) (str.to_re "-20") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "29-02-20") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6")))))) (str.to_re "\u{0a}")))))
; ^[0-9]+\.?[0-9]?[0-9]?[0,5]?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ".")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.union (str.to_re "0") (str.to_re ",") (str.to_re "5"))) (str.to_re "\u{0a}"))))
; ^-?\d{1,3}\.(\d{3}\.)*\d{3},\d\d$|^-?\d{1,3},\d\d$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "."))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.range "0" "9") (re.range "0" "9") (str.to_re "\u{0a}"))))))
(check-sat)
