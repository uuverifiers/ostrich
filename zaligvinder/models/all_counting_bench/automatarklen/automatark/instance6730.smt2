(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\b(10|11|12|13|14|15|16|17|18|19)[0-9]\b)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.range "0" "9") (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "8") (str.to_re "9"))))))
; ^\${1}[a-z]{1}[a-z\d]{0,6}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "$")) ((_ re.loop 1 1) (re.range "a" "z")) ((_ re.loop 0 6) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /update\/barcab\/.*?tn=.*id=.*version=/smi
(assert (not (str.in_re X (re.++ (str.to_re "/update/barcab/") (re.* re.allchar) (str.to_re "tn=") (re.* re.allchar) (str.to_re "id=") (re.* re.allchar) (str.to_re "version=/smi\u{0a}")))))
; /filename=[^\n]*\u{2e}abc/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".abc/i\u{0a}"))))
; ^\d{2}(\u{2e})(\d{3})(-\d{3})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
