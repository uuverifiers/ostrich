(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(\/\d{8,11})?(\/\d)?\/1[34]\d{8}\.htm$/U
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (re.++ (str.to_re "/") ((_ re.loop 8 11) (re.range "0" "9")))) (re.opt (re.++ (str.to_re "/") (re.range "0" "9"))) (str.to_re "/1") (re.union (str.to_re "3") (str.to_re "4")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re ".htm/U\u{0a}")))))
; ^([0-1][0-9]|2[0-3]){1}:([0-5][0-9]){1}:([0-5][0-9]){1},([0-9][0-9][0-9]){1} --> ([0-1][0-9]|2[0-3]){1}:([0-5][0-9]){1}:([0-5][0-9]){1},([0-9][0-9][0-9]){1}(.*)$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 1 1) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re " --> ") ((_ re.loop 1 1) (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ":") ((_ re.loop 1 1) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re ",") ((_ re.loop 1 1) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (re.* re.allchar) (str.to_re "\u{0a}"))))
; \x2FGR.*Report.*Host\x3APopup\.cfg
(assert (not (str.in_re X (re.++ (str.to_re "/GR") (re.* re.allchar) (str.to_re "Report") (re.* re.allchar) (str.to_re "Host:Popup.cfg\u{0a}")))))
; ^[-]?([1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|\.[0-9]{1,2})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; From\x3A\w+SoftActivity\d+
(assert (not (str.in_re X (re.++ (str.to_re "From:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "SoftActivity\u{13}") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
