(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\.{0,2}[\/\\]
(assert (not (str.in_re X (re.++ ((_ re.loop 0 2) (str.to_re ".")) (re.union (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "\u{0a}")))))
; Host\x3A\s+lnzzlnbk\u{2f}pkrm\.fin
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin\u{0a}")))))
; /filename=[^\n]*\u{2e}otf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".otf/i\u{0a}"))))
(check-sat)
