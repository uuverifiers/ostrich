(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([01]\d|2[0123])([0-5]\d){2}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (str.to_re "3")))) ((_ re.loop 2 2) (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; [A-Za-z]+
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}zip/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".zip/i\u{0a}")))))
; Referer\x3A.*notification.*qisezhin\u{2f}iqor\.ymspasServer\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Referer:") (re.* re.allchar) (str.to_re "notification\u{13}") (re.* re.allchar) (str.to_re "qisezhin/iqor.ym\u{13}spasServer:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
