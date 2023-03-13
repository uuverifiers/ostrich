(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3AIPAsynchaveAdToolszopabora\x2Einfo
(assert (str.in_re X (str.to_re "Host:IPAsynchaveAdToolszopabora.info\u{0a}")))
; ^((\+)?(\d{2}[-]))?(\d{10}){1}?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-"))) ((_ re.loop 1 1) ((_ re.loop 10 10) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
