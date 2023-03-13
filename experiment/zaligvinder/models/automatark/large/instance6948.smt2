(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([1][0-2])|([0]?[1-9]{1}))\/(([0-2]?\d{1})|([3][0,1]{1}))\/(([1]{1}[9]{1}[9]{1}\d{1})|([2-9]{1}\d{3}))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (re.opt (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9")))) (str.to_re "/") (re.union (re.++ (re.opt (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (str.to_re "3") ((_ re.loop 1 1) (re.union (str.to_re "0") (str.to_re ",") (str.to_re "1"))))) (str.to_re "/") (re.union (re.++ ((_ re.loop 1 1) (str.to_re "1")) ((_ re.loop 1 1) (str.to_re "9")) ((_ re.loop 1 1) (str.to_re "9")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /g\/\d{9}\/[0-9a-f]{32}\/[0-9]$/U
(assert (not (str.in_re X (re.++ (str.to_re "/g/") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/") (re.range "0" "9") (str.to_re "/U\u{0a}")))))
; The company delivers cakes and also online send mothers  day flowers to Delhi.
(assert (str.in_re X (re.++ (str.to_re "The company delivers cakes and also online send mothers  day flowers to Delhi") re.allchar (str.to_re "\u{0a}"))))
; X-Mailer\u{3a}.*User-Agent\x3A[^\n\r]*ulmxct\u{2f}mqoyc
(assert (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.* re.allchar) (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "ulmxct/mqoyc\u{0a}"))))
; /filename=[^\n]*\u{2e}3gp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".3gp/i\u{0a}"))))
(check-sat)
