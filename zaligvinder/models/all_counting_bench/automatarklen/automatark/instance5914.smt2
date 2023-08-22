(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^.{0,0}
(assert (not (str.in_re X (re.++ ((_ re.loop 0 0) re.allchar) (str.to_re "\u{0a}")))))
; ^(\+{1}|00)\s{0,1}([0-9]{3}|[0-9]{2})\s{0,1}\-{0,1}\s{0,1}([0-9]{2}|[1-9]{1})\s{0,1}\-{0,1}\s{0,1}([0-9]{8}|[0-9]{7})
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (str.to_re "+")) (str.to_re "00")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "1" "9"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union ((_ re.loop 8 8) (re.range "0" "9")) ((_ re.loop 7 7) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
