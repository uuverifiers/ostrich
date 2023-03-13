(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; addrwww\x2Etrustedsearch\x2EcomX-Mailer\x3A
(assert (not (str.in_re X (str.to_re "addrwww.trustedsearch.comX-Mailer:\u{13}\u{0a}"))))
; ((FI|HU|LU|MT|SI)-?)?[0-9]{8}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "FI") (str.to_re "HU") (str.to_re "LU") (str.to_re "MT") (str.to_re "SI")) (re.opt (str.to_re "-")))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
