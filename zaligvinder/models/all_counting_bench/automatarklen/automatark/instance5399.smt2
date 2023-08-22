(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}jnlp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jnlp/i\u{0a}")))))
; /^\/[0-9]{8}\.html$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re ".html/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
