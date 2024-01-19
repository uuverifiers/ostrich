(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}apk/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".apk/i\u{0a}"))))
; ^.{4,8}$
(assert (str.in_re X (re.++ ((_ re.loop 4 8) re.allchar) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
