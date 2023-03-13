(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([\d]{4}[ |-]?){2}([\d]{11}[ |-]?)([\d]{2})
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-"))))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}") ((_ re.loop 11 11) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-")))))))
; ^([01][012]|0[1-9])/([0-2][0-9]|[3][0-1])/([0-9][0-9][0-9][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2"))) (re.++ (str.to_re "0") (re.range "1" "9"))) (str.to_re "/") (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) (str.to_re "/\u{0a}") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))))
; \u{7c}roogoo\u{7c}Testiufilfwulmfi\u{2f}riuf\.lioHeaders
(assert (str.in_re X (str.to_re "|roogoo|Testiufilfwulmfi/riuf.lioHeaders\u{0a}")))
(check-sat)
