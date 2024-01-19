(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\-?\(?([0-9]{0,3}(\,?[0-9]{3})*(\.?[0-9]*))\)?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "(")) (re.opt (str.to_re ")")) (str.to_re "\u{0a}") ((_ re.loop 0 3) (re.range "0" "9")) (re.* (re.++ (re.opt (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (str.to_re ".")) (re.* (re.range "0" "9"))))))
; (^[0-9]{2,3}\.[0-9]{3}\.[0-9]{3}\/[0-9]{4}-[0-9]{2}$)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}mppl/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mppl/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
