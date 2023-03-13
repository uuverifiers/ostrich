(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; rank\x2Etoolbarbrowser\x2Ecomlnzzlnbk\u{2f}pkrm\.fin
(assert (str.in_re X (str.to_re "rank.toolbarbrowser.comlnzzlnbk/pkrm.fin\u{0a}")))
; ^-?((([0-9]{1,3},)?([0-9]{3},)*?[0-9]{3})|([0-9]{1,3}))\.[0-9]*$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ (re.opt (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ","))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 1 3) (re.range "0" "9"))) (str.to_re ".") (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
