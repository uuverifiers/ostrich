(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\?id=[A-Z0-9]{20}&cmd=img/U
(assert (str.in_re X (re.++ (str.to_re "/?id=") ((_ re.loop 20 20) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "&cmd=img/U\u{0a}"))))
(check-sat)
