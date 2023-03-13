(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{1,2})(\s?(H|h)?)(:([0-5]\d))?$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "H") (str.to_re "h"))))))
; HTTPwwwProbnymomspyo\u{2f}zowy
(assert (str.in_re X (str.to_re "HTTPwwwProbnymomspyo/zowy\u{0a}")))
; /^[0-9]+\.d{3}? *$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re ".") ((_ re.loop 3 3) (str.to_re "d")) (re.* (str.to_re " ")) (str.to_re "/\u{0a}")))))
(check-sat)
