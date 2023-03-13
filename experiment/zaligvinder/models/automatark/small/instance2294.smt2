(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-fA-F])*$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "\u{0a}")))))
; ^\[0-9]{4}\-\[0-9]{2}\-\[0-9]{2}$
(assert (not (str.in_re X (re.++ (str.to_re "[0-9") ((_ re.loop 4 4) (str.to_re "]")) (str.to_re "-[0-9") ((_ re.loop 2 2) (str.to_re "]")) (str.to_re "-[0-9") ((_ re.loop 2 2) (str.to_re "]")) (str.to_re "\u{0a}")))))
; Host\x3AHost\x3Aalertseqepagqfphv\u{2f}sfd
(assert (str.in_re X (str.to_re "Host:Host:alertseqepagqfphv/sfd\u{0a}")))
(check-sat)
