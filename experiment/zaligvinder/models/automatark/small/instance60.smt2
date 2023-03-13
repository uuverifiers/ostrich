(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; "^[A-Z]{1}\d{7}$
(assert (not (str.in_re X (re.++ (str.to_re "\u{22}") ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\x3AIPAsynchaveAdToolszopabora\x2Einfo
(assert (not (str.in_re X (str.to_re "Host:IPAsynchaveAdToolszopabora.info\u{0a}"))))
(check-sat)
