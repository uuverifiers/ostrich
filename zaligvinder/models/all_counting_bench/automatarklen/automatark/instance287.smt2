(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /update\/barcab\/.*?tn=.*id=.*version=/smi
(assert (str.in_re X (re.++ (str.to_re "/update/barcab/") (re.* re.allchar) (str.to_re "tn=") (re.* re.allchar) (str.to_re "id=") (re.* re.allchar) (str.to_re "version=/smi\u{0a}"))))
; ^[F][O][\s]?[0-9]{3}$
(assert (not (str.in_re X (re.++ (str.to_re "FO") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
