(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Pass-Onseqepagqfphv\u{2f}sfdcargo=dnsgpstool\u{2e}globaladserver\u{2e}com
(assert (not (str.in_re X (str.to_re "Pass-Onseqepagqfphv/sfdcargo=dnsgpstool.globaladserver.com\u{0a}"))))
; /^\/[A-Z]{6}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 6 6) (re.range "A" "Z")) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
