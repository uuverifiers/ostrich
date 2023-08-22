(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([L|U]{1})([0-9]{5})([A-Za-z]{2})([0-9]{4})([A-Za-z]{3})([0-9]{6})$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (str.to_re "L") (str.to_re "|") (str.to_re "U"))) ((_ re.loop 5 5) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; HTTPwwwProbnymomspyo\u{2f}zowy
(assert (not (str.in_re X (str.to_re "HTTPwwwProbnymomspyo/zowy\u{0a}"))))
; as\x2Estarware\x2Ecom%3fUser-Agent\x3Ahostie
(assert (not (str.in_re X (str.to_re "as.starware.com%3fUser-Agent:hostie\u{0a}"))))
; ^([\+][0-9]{1,3}[\.][0-9]{1,12})([x]?[0-9]{1,4}?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}+") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 12) (re.range "0" "9")) (re.opt (str.to_re "x")) ((_ re.loop 1 4) (re.range "0" "9")))))
; (\{\\f\d*)\\([^;]+;)
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}\u{0a}{\u{5c}f") (re.* (re.range "0" "9")) (re.+ (re.comp (str.to_re ";"))) (str.to_re ";")))))
(assert (> (str.len X) 10))
(check-sat)
