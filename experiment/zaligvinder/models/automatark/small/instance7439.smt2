(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; InformationSubject\x3ASpynovabyBlacksnprtz\x7CdialnoSearch
(assert (not (str.in_re X (str.to_re "InformationSubject:SpynovabyBlacksnprtz|dialnoSearch\u{0a}"))))
; /^(8-?|\+?7-?)?(\(?\d{3}\)?)-?(\d-?){6}\d$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (re.++ (str.to_re "8") (re.opt (str.to_re "-"))) (re.++ (re.opt (str.to_re "+")) (str.to_re "7") (re.opt (str.to_re "-"))))) (re.opt (str.to_re "-")) ((_ re.loop 6 6) (re.++ (re.range "0" "9") (re.opt (str.to_re "-")))) (re.range "0" "9") (str.to_re "/\u{0a}") (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")"))))))
(check-sat)
