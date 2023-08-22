(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}xslt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xslt/i\u{0a}"))))
; ^[A-Z]{1,3}\d{6}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "A" "Z")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; X-Mailer\u{3a}.*User-Agent\x3A[^\n\r]*ulmxct\u{2f}mqoyc
(assert (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.* re.allchar) (str.to_re "User-Agent:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "ulmxct/mqoyc\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
