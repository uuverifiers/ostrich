(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Test\d+DesktopAddressIDENTIFY666User-Agent\x3A\x5BStatic
(assert (str.in_re X (re.++ (str.to_re "Test") (re.+ (re.range "0" "9")) (str.to_re "DesktopAddressIDENTIFY666User-Agent:[Static\u{0a}"))))
; ^(((((((00|\+)49[ \-/]?)|0)[1-9][0-9]{1,4})[ \-/]?)|((((00|\+)49\()|\(0)[1-9][0-9]{1,4}\)[ \-/]?))[0-9]{1,7}([ \-/]?[0-9]{1,5})?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))) (re.union (re.++ (re.union (str.to_re "00") (str.to_re "+")) (str.to_re "49") (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/")))) (str.to_re "0")) (re.range "1" "9") ((_ re.loop 1 4) (re.range "0" "9"))) (re.++ (re.union (re.++ (re.union (str.to_re "00") (str.to_re "+")) (str.to_re "49(")) (str.to_re "(0")) (re.range "1" "9") ((_ re.loop 1 4) (re.range "0" "9")) (str.to_re ")") (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))))) ((_ re.loop 1 7) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re "/"))) ((_ re.loop 1 5) (re.range "0" "9")))))))
; ^([987]{1})(\d{1})(\d{8})
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "9") (str.to_re "8") (str.to_re "7"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
