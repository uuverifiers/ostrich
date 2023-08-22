(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{22}Thewebsearch\.getmirar\.com
(assert (not (str.in_re X (str.to_re "\u{22}Thewebsearch.getmirar.com\u{0a}"))))
; ^[{|\(]?[0-9a-fA-F]{8}[-]?([0-9a-fA-F]{4}[-]?){3}[0-9a-fA-F]{12}[\)|}]?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "{") (str.to_re "|") (str.to_re "("))) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (str.to_re "-")))) ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (re.union (str.to_re ")") (str.to_re "|") (str.to_re "}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
