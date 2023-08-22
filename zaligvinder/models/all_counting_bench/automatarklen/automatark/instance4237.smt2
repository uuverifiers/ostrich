(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-1]?[1-9]|2[0-3])(:)([0-5][0-9]))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "1" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))))
; ^(-|\+)?(((100|((0|[1-9]{1,2})(\.[0-9]+)?)))|(\.[0-9]+))%?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.union (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))) (str.to_re "100") (re.++ (re.union (str.to_re "0") ((_ re.loop 1 2) (re.range "1" "9"))) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))))) (re.opt (str.to_re "%")) (str.to_re "\u{0a}")))))
; /\/setup_b\.asp\?prj=\d\u{26}pid=[^\r\n]*\u{26}mac=/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//setup_b.asp?prj=") (re.range "0" "9") (str.to_re "&pid=") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "&mac=/Ui\u{0a}")))))
; /^.{27}/sR
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 27 27) re.allchar) (str.to_re "/sR\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
