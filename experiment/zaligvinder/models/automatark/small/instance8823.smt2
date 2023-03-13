(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mka/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mka/i\u{0a}")))))
; com\dsearch\u{2e}conduit\u{2e}com\s+User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "com") (re.range "0" "9") (str.to_re "search.conduit.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}")))))
; \w*$
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
; ^([9]{1})+(6|3|2|1{1})+([0-9]{7})$
(assert (not (str.in_re X (re.++ (re.+ ((_ re.loop 1 1) (str.to_re "9"))) (re.+ (re.union (str.to_re "6") (str.to_re "3") (str.to_re "2") ((_ re.loop 1 1) (str.to_re "1")))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
