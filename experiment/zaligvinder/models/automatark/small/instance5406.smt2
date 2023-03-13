(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/stat_svc\/$/U
(assert (not (str.in_re X (str.to_re "//stat_svc//U\u{0a}"))))
; ^[1-4]{1}[0-9]{4}(-)?[0-9]{7}(-)?[0-9]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "4")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
